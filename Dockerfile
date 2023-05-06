# syntax=docker/dockerfile:1.4

FROM rust:1.68.0 AS builder

ARG TARGETPLATFORM

WORKDIR /build

COPY . .

RUN --mount=type=cache,target=/usr/local/cargo/registry,id=${TARGETPLATFORM} --mount=type=cache,target=/build/target,id=${TARGETPLATFORM} \
    cargo build --release  --bin  rust-docker-demo && \
    mv /build/target/release/rust-docker-demo /build

FROM gcr.io/distroless/cc:latest as runtime

COPY --from=builder  /build/rust-docker-demo /rust-docker-demo

CMD ["/rust-docker-demo"]
