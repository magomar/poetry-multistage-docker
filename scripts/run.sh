#!/bin/sh

set -e

CURRENT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BASE_DIR="$(dirname "$CURRENT_DIR")"

cd "$BASE_DIR"

docker build --tag poetry-docker:latest --file docker/Dockerfile .
docker run -t --rm poetry-docker:latest "$@"