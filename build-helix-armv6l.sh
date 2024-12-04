#!/bin/bash

# Set CARGO_BUILD_JOBS environment variable to utilize 95% of available CPU cores for building.
# Comment out or change to your discretion.
export CARGO_BUILD_JOBS=$(($(nproc) * 95 / 100))
echo "CARGO_BUILD_JOBS set to $CARGO_BUILD_JOBS"

# Set additional environment variables for static linking
export RUSTFLAGS="-C target-feature=+crt-static"
export OPENSSL_STATIC=1
export OPENSSL_LIB_DIR=/usr/lib/arm-linux-gnueabi
export OPENSSL_INCLUDE_DIR=/usr/include

# Verify and build for the required Rust target
rustup target add arm-unknown-linux-gnueabi && \
echo "Installed Target(s):" && \
rustup target list --installed && \
cargo build -vv \
    --target=arm-unknown-linux-gnueabi \
    --release
