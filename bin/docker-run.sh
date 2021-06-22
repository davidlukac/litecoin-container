#!/usr/bin/env bash

# Run Litecoin image with mounted data folder.

set -xe

declare APP
declare APP_VER
declare REPO_URL

# shellcheck source=.env
source .env

docker run \
  --rm \
  -it \
  --name "${APP}" \
  -v "$(pwd)/data/0":/home/litecoin/.litecoin \
  -v "$(pwd)/deploy-resources/litecoin.conf":/home/litecoin/.litecoin.conf:ro \
  "${REPO_URL}/${APP}:${APP_VER}"
