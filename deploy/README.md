# Deploy

| Setup | Where it runs | Database |
|---|---|---|
| `production/` | Docker: app container + Postgres 16 container | `instrument_db` inside the `db` container (host port 5436) |
| `local/` | Your machine: `uvicorn --reload` against the code in `app/` | `instrument_db` in your local Postgres (port 5432) |

Both read the database URL from a `.env` file in their own folder. `.env` files are git-ignored. Copy `.env.example` to make one.

## Local development

You need Python 3.12 and a local Postgres that has `instrument_db` restored. For example, from the latest prod dump:

```bash
createdb -h localhost -U postgres instrument_db
psql -h localhost -U postgres -d instrument_db < db_backup/16Nov_instru_instru.sql
```

Then:

```bash
cp deploy/local/.env.example deploy/local/.env   # set your password
./deploy/local/run.sh
```

The script creates `.venv` in the repo root on the first run and installs `requirements.txt` again whenever that file changes. It then serves the app at http://127.0.0.1:8000 (API docs at `/docs`) and reloads when files in `app/` change.

## Production

On the server, from the repo:

```bash
cp deploy/production/.env.example deploy/production/.env   # set the real POSTGRES_PASSWORD
./deploy/production/deploy.sh
```

The script:

1. Starts Postgres and waits until it is ready.
2. Finds the latest `.sql` file in `db_backup/` and asks **"Restore it? [y/N]"**. The default is No.
3. If you answer yes, it:
   - stops the app
   - saves the current database to `db_backup/pre_restore/` (git-ignored)
   - drops and recreates `instrument_db`
   - loads the backup, stopping at the first error
4. Builds and starts the app.

Flags to skip the question: `--restore` restores the latest backup without asking, and `--no-restore` deploys and keeps the current data. Without a terminal, for example in CI, the script never restores unless you pass `--restore`.

"Latest" means the file in `db_backup/` that was committed to git most recently. A file you copied in but haven't committed counts by its modified time, so it wins. Name new backups with a date, for example `instrument_db_20261116.sql`.

The app is served on port **8083** and Postgres on **5436**, the same ports as before.

### Moving over from the root `docker-compose.yml`

This compose file sets `name: instrument_sys`, so it reuses the existing `instrument_sys_postgres_data` volume and the existing data. Before switching:

1. Check the volume name: `docker volume ls | grep postgres_data`. If the server's prefix is not `instrument_sys` (it comes from the repo folder name on that server), change `name:` in `production/docker-compose.yml` to match.
2. Take a backup first:
   ```bash
   docker compose exec db pg_dump -U postgres -d instrument_db --no-owner > ~/instrument_db_$(date +%Y%m%d).sql
   ```
3. Stop the old stack from the repo root (`docker compose down`, **without** `-v`), then run `./deploy/production/deploy.sh`.

### Fresh server

Run `deploy.sh` and answer **y**. Postgres creates an empty `instrument_db`, and the script fills it from the latest file in `db_backup/`.

### Taking a new backup

From `deploy/production`:

```bash
docker compose exec -T db pg_dump -U postgres -d instrument_db --no-owner > ../../db_backup/instrument_db_$(date +%Y%m%d).sql
```

Commit the file to make it the latest backup for the next deploy.
