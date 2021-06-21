#!/usr/bin/env bash

# Push Litecoin image to the registry.

set -xe

declare APP
declare APP_VER
declare REPO_URL

source .env

docker push "${REPO_URL}/${APP}:${APP_VER}"
