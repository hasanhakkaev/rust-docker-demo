# syntax=docker/dockerfile:1.4

FROM lukemathwalker/cargo-chef:latest-rust-1.68.0 AS chef

ARG TARGETPLATFORM

WORKDIR /build

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /build/recipe.json recipe.json

# Build dependencies - this is the caching Docker layer!
RUN --mount=type=cache,target=/usr/local/cargo/registry,id=${TARGETPLATFORM} --mount=type=cache,target=/build/target,id=${TARGETPLATFORM} \
    cargo chef cook --release --recipe-path recipe.json

COPY . .

# Build the application
RUN --mount=type=cache,target=/usr/local/cargo/registry,id=${TARGETPLATFORM} --mount=type=cache,target=/build/target,id=${TARGETPLATFORM} \
    cargo build --release  --bin  rust-docker-demo && \
    mv /build/target/release/rust-docker-demo /build

FROM gcr.io/distroless/cc:latest as runtime

COPY --from=builder  /build/rust-docker-demo /rust-docker-demo

CMD ["/rust-docker-demo"]
