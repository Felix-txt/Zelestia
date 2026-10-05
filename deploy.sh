#!/bin/bash

set -e

cleanup() {
    docker compose down
}
trap cleanup EXIT SIGINT

git pull

docker compose up -d

export SECRET_KEY_BASE=$(mix phx.gen.secret 64)
export DATABASE_URL=eto://user:postgres@localhost/zelestia
read -p "Host? " host
export PHX_HOST=$host
read -p "Port? " port
export PORT=$port
read -p "http or https? " scheme
export SCHEME=$scheme

npm install

mix deps.get --only prod
MIX_ENV=prod mix compile

MIX_ENV=prod mix assets.deploy

MIX_ENV=prod mix phx.server
