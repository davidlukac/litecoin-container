#!/usr/bin/env bash

# Run Litecoin image with mounted data folder.

set -xe

declare APP
declare APP_VER
declare REPO_URL

source .env

docker run \
  --rm \
  -it \
  --name "${APP}" \
  -v $(pwd)/data:/home/litecoin/.litecoin \
  "${REPO_URL}/${APP}:${APP_VER}"
