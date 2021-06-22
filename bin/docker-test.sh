#!/usr/bin/env bash

# Lint dockerfiles and check for security vulnerabilities.

set -xe

declare APP

source .env

hadolint Dockerfile
hadolint alpine.dockerfile

grype -q "sbom:./build/${APP}.sbom.json"
