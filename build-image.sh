#!/bin/bash

# Build the Docker image with BuildKit.
docker buildx build \
    --build-arg USERNAME=$(whoami) \
    --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    -t neilpandya/rust:slim-bookworm-crosscompile-armv6l . \
    --load
