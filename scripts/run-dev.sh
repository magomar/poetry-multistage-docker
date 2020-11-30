#!/bin/sh

set -e

CURRENT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BASE_DIR="$(dirname "$CURRENT_DIR")"

cd "$BASE_DIR"

#docker container prune -f
docker build --tag poetry-docker --file docker/Dockerfile --target development .
docker run  -v /home/mario/workspace/python/poetry-docker/:/app/ -it poetry-docker:dev