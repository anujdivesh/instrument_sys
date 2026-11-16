#!/usr/bin/env bash
# Local dev: runs the FastAPI app directly (no Docker) with auto-reload,
# against a Postgres database you have restored locally.
#
#   ./deploy/local/run.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing $ENV_FILE - copy .env.example to .env and set DATABASE_URL." >&2
  exit 1
fi
set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

cd "$ROOT"

# Virtualenv in the repo root (.venv is git-ignored). Prefers Python 3.12 to match the Docker image.
if [[ ! -d .venv ]]; then
  PYTHON="${PYTHON:-$(command -v python3.12 || command -v python3)}"
  echo "Creating .venv with $PYTHON"
  "$PYTHON" -m venv .venv
fi
# shellcheck disable=SC1091
source .venv/bin/activate

# Reinstall dependencies only when requirements.txt changes.
STAMP=".venv/.requirements.sha"
REQ_SHA="$(shasum requirements.txt | cut -d' ' -f1)"
if [[ ! -f "$STAMP" || "$(cat "$STAMP")" != "$REQ_SHA" ]]; then
  pip install -q --upgrade pip
  pip install -q -r requirements.txt
  echo "$REQ_SHA" > "$STAMP"
fi

mkdir -p app/uploads/documents

echo "Starting on http://${HOST:-127.0.0.1}:${PORT:-8000}  (docs: /docs)"
exec uvicorn app.main:app --host "${HOST:-127.0.0.1}" --port "${PORT:-8000}" --reload --reload-dir app
