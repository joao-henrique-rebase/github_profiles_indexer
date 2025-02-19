#!/bin/sh
set -e

if ! command -v node > /dev/null; then
  echo "Instalando Node.js e npm..."
  apt-get update -qq && apt-get install -y nodejs npm
fi

npm install

bundle install

rm -f tmp/pids/server.pid

exec "$@"
