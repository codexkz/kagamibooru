#!/usr/bin/dumb-init /bin/sh
set -e
cd /opt/app

alembic upgrade head

echo "Starting kagamibooru API on port ${PORT} - Running on ${THREADS} threads"
exec hupper -m waitress --listen "*:${PORT}" --threads ${THREADS} kagamibooru.facade:app
