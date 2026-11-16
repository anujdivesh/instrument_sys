#!/usr/bin/env bash
# Production deploy: builds and starts the Docker stack, and offers to restore
# the latest backup from db_backup/ into the database first.
#
#   ./deploy/production/deploy.sh               # asks whether to restore
#   ./deploy/production/deploy.sh --restore     # restore latest backup, no prompt
#   ./deploy/production/deploy.sh --no-restore  # just deploy, keep current data
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BACKUP_DIR="$ROOT/db_backup"
SAFETY_DIR="$BACKUP_DIR/pre_restore"
ENV_FILE="$SCRIPT_DIR/.env"

RESTORE="ask"
case "${1:-}" in
  --restore)    RESTORE="yes" ;;
  --no-restore) RESTORE="no" ;;
  "")           ;;
  *) echo "Usage: $0 [--restore|--no-restore]" >&2; exit 2 ;;
esac

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing $ENV_FILE - copy .env.example to .env and set POSTGRES_PASSWORD." >&2
  exit 1
fi
set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a
DB_USER="${POSTGRES_USER:-postgres}"
DB_NAME="${POSTGRES_DB:-instrument_db}"

dc() { docker compose -f "$SCRIPT_DIR/docker-compose.yml" --env-file "$ENV_FILE" "$@"; }
psql_db() { dc exec -T db psql -v ON_ERROR_STOP=1 -U "$DB_USER" "$@"; }

# Newest .sql in db_backup/: last git commit time for committed files,
# file modified time for files that are not committed yet.
latest_backup() {
  local f t best="" best_t=0
  shopt -s nullglob
  for f in "$BACKUP_DIR"/*.sql; do
    t="$(git -C "$ROOT" log -1 --format=%ct -- "$f" 2>/dev/null || true)"
    [[ -z "$t" ]] && t="$(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f")"
    if (( t > best_t )); then best="$f"; best_t="$t"; fi
  done
  shopt -u nullglob
  echo "$best"
}

echo "==> Starting database"
dc up -d db
echo -n "    waiting for Postgres"
for _ in $(seq 1 60); do
  if dc exec -T db pg_isready -U "$DB_USER" -q; then break; fi
  echo -n "."; sleep 2
done
echo
dc exec -T db pg_isready -U "$DB_USER" -q || { echo "Postgres did not become ready." >&2; exit 1; }

BACKUP_FILE="$(latest_backup)"
if [[ "$RESTORE" != "no" && -z "$BACKUP_FILE" ]]; then
  echo "No .sql files in $BACKUP_DIR - skipping restore."
  RESTORE="no"
fi

if [[ "$RESTORE" == "ask" ]]; then
  echo
  echo "Latest backup: ${BACKUP_FILE#"$ROOT"/} ($(du -h "$BACKUP_FILE" | cut -f1))"
  echo "Restoring REPLACES all current data in '$DB_NAME' with this file."
  echo "(The current database is saved to db_backup/pre_restore/ first.)"
  if [[ -t 0 ]]; then
    read -r -p "Restore it? [y/N] " answer
  else
    echo "No terminal to ask on - not restoring. Use --restore to restore without a prompt."
    answer="n"
  fi
  [[ "$answer" =~ ^[Yy]([Ee][Ss])?$ ]] && RESTORE="yes" || RESTORE="no"
fi

if [[ "$RESTORE" == "yes" ]]; then
  echo "==> Stopping app"
  dc stop app 2>/dev/null || true

  exists="$(psql_db -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'")"
  if [[ "$exists" == "1" ]]; then
    mkdir -p "$SAFETY_DIR"
    SAFETY_FILE="$SAFETY_DIR/${DB_NAME}_before_restore_$(date +%Y%m%d_%H%M%S).sql"
    echo "==> Saving current database to ${SAFETY_FILE#"$ROOT"/}"
    dc exec -T db pg_dump -U "$DB_USER" -d "$DB_NAME" --no-owner > "$SAFETY_FILE"
  fi

  trap 'echo "Restore FAILED. The app is stopped. Previous data: ${SAFETY_FILE:-none}" >&2' ERR
  echo "==> Restoring ${BACKUP_FILE#"$ROOT"/} into $DB_NAME"
  psql_db -d postgres -c "DROP DATABASE IF EXISTS \"$DB_NAME\" WITH (FORCE);" -c "CREATE DATABASE \"$DB_NAME\";"
  psql_db -q -d "$DB_NAME" < "$BACKUP_FILE" > /dev/null
  trap - ERR
  echo "    restore complete"
fi

echo "==> Building and starting app"
dc up -d --build

echo
dc ps
echo
echo "Done. App: http://localhost:${APP_PORT:-8083}/insitu/docs"
