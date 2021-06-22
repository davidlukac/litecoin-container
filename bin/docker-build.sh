#!/usr/bin/env bash

# Build Litecoin docker image.

set -xe

declare APP
declare APP_VER
declare DEBIAN_VER
declare LITECOIN_VER
declare REPO_URL

source .env

BINARIES_DIR="./build"

# Re-download binary resources if folder doesn't exists or is empty.
if [ ! -d "${BINARIES_DIR}" ] || [ -z "$(ls -A ${BINARIES_DIR})" ] ; then
  bin/get-binaries.sh
fi

docker build \
  --build-arg "APP=${APP}" \
  --build-arg "APP_VER=${APP_VER}" \
  --build-arg "DEBIAN_VER=${DEBIAN_VER}" \
  --build-arg "LITECOIN_VER=${LITECOIN_VER}" \
  --no-cache \
  -f Dockerfile \
  -t "${REPO_URL}/${APP}:${APP_VER}" \
  .

# Generate BOM from the build image.
syft "${REPO_URL}/${APP}:${APP_VER}" --scope squashed -o json -q > "build/${APP}.sbom.json"
