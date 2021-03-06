#!/usr/bin/env bash

# Lint dockerfiles and check for security vulnerabilities.

set -xe

declare APP

# shellcheck source=.env
source .env

hadolint Dockerfile
hadolint alpine.dockerfile


if [ -z ${CI+x} ]; then
  grype -q "sbom:./build/${APP}.sbom.json"
else
  #  < "build/${APP}.sbom.json" docker run --rm -i anchore/grype -f "$(yq e '.fail-on-severity' .grype.yaml)" -s "$(yq e '.scope' .grype.yaml)" -q
  docker run --rm -v "$(pwd)":/opt/app anchore/grype "sbom:/opt/app/build/${APP}.sbom.json"
fi
