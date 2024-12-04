FROM rust:slim-bookworm

LABEL maintainer="neil@neilpandya.com"
LABEL org.opencontainers.image.source="https://hub.docker.com/repository/docker/neilpandya/rust"
LABEL description="This image is meant for cross-compilation \
    from an `amd64` base image/host to an `armv6l` target."
LABEL version="1.82.0"

# Set arguments for dynamic UID, GID, and username
ARG USERNAME
ARG UID
ARG GID

# Install required packages for cross-compilation and static linking
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    pkg-config \
    git \
    wget \
    gcc-arm-linux-gnueabi \
    g++-arm-linux-gnueabi \
    libc6-dev-armel-cross \
    libgcc-12-dev-armel-cross \
    libstdc++-12-dev-armel-cross \
    libssl-dev \
    zlib1g-dev \
    build-essential \
    cmake \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install cross for cross-compilation and set up the ARM target
RUN rustup target add arm-unknown-linux-gnueabi && \
    echo "Installed Target(s):" && \
    rustup target list --installed

# Set environment variables for cross-compilation
ENV CC_arm_unknown_linux_gnueabi=arm-linux-gnueabi-gcc
ENV CXX_arm_unknown_linux_gnueabi=arm-linux-gnueabi-g++
ENV AR_arm_unknown_linux_gnueabi=arm-linux-gnueabi-ar
ENV CARGO_TARGET_ARM_UNKNOWN_LINUX_GNUEABI_LINKER=arm-linux-gnueabi-gcc

# Set permissions for cargo
RUN chmod -v -R 777 /usr/local/cargo

# Create non-root user with the provided UID and GID
RUN groupadd -g $GID $USERNAME && \
    useradd -u $UID -g $GID -s /bin/bash $USERNAME

ENTRYPOINT ["bash"]
