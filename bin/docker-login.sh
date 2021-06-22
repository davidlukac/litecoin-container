#!/usr/bin/env bash

# Perform AWS ECR Docker login

set -xe

# Defined as secret/Travis variables.
declare AWS_ACCESS_KEY_ID
declare AWS_SECRET_ACCESS_KEY
declare AWS_DEFAULT_REGION

# shellcheck source=.env
source .env

aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"
aws configure set default.region "${AWS_DEFAULT_REGION}"

# Attempt to do Docker login; we will know it failed if the next step fails.
rm -f screenlog.0
screen -dmL sh -c "aws ecr get-login-password --region \"${AWS_DEFAULT_REGION}\" | docker login --username AWS --password-stdin \"${REPO_URL}\""
sleep 3
cat screenlog.0
