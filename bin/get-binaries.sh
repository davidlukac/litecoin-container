#!/usr/bin/env bash

# Download binaries needed for Docker build and verify theirs checksums.

set -xe

declare LITECOIN_VER

source .env

mkdir -p build/litecoin
mkdir -p build/glibc

LITECOIN_GPG="FE3348877809386C"
LITECOIN_SRC="https://download.litecoin.org/litecoin-${LITECOIN_VER}/linux/litecoin-${LITECOIN_VER}-x86_64-linux-gnu.tar.gz"
LITECOIN_ASC="https://download.litecoin.org/litecoin-${LITECOIN_VER}/linux/litecoin-${LITECOIN_VER}-linux-signatures.asc"

curl -s -f -L -S "${LITECOIN_SRC}" -o build/litecoin.tar.gz
curl -s -f -L -S "${LITECOIN_ASC}" -o build/litecoin.asc

KEY_SERVERS=("pgp.mit.edu" "keyserver.pgp.com" "ha.pool.sks-keyservers.net" "hkp://p80.pool.sks-keyservers.net:80")
for KEY_SERVER in "${KEY_SERVERS[@]}"; do
  gpg --no-tty --keyserver "${KEY_SERVER}" --recv-keys "${LITECOIN_GPG}" || true
done

# If none of the key servers were able to provide the public signature, the validation will fail.
gpg --verify build/litecoin.asc
grep x86_64-linux build/litecoin.asc | awk '{print $1 "  build/litecoin.tar.gz"}' | shasum -a 256 --check --strict

tar --strip=2 -xzf build/litecoin.tar.gz -C build/litecoin

GLIBC_VER="2.33-r0"
GLIBC_RSA="https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub"
GLIBC_SRC="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk"
GLIBC_BIN_SRC="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk"

curl -sfLS ${GLIBC_RSA} -o build/glibc/sgerrand.rsa.pub
curl -sfLS ${GLIBC_SRC} -o build/glibc/glibc-${GLIBC_VER}.apk
curl -sfLS ${GLIBC_BIN_SRC} -o build/glibc/glibc-bin-${GLIBC_VER}.apk
