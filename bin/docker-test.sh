#!/usr/bin/env bash

# Lint dockerfiles and check for security vulnerabilities.

set -xe

declare APP

source .env

hadolint Dockerfile
hadolint alpine.dockerfile


if [ -z ${CI+x} ]; then
  grype -q "sbom:./build/${APP}.sbom.json"
else
  docker run --rm -v $(pwd):/opt/app anchore/grype "sbom:/opt/app/build/${APP}.sbom.json"
fi
