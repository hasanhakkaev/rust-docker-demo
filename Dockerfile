# syntax=docker/dockerfile:1.4

FROM rust:1.68.2 as builder

ARG TARGET

WORKDIR /build

RUN apt-get update \
    && ( apt-get install -y gcc-multilib || echo "Warning: not installing gcc-multilib" ) \
    && apt-get install -y clang cmake gcc-aarch64-linux-gnu g++-aarch64-linux-gnu protobuf-compiler

COPY . .

RUN echo "Building for $TARGET"
RUN --mount=type=cache,target=/usr/local/cargo/registry,id=${TARGETPLATFORM} --mount=type=cache,target=/build/target,id=${TARGETPLATFORM} \
    rustup target add ${TARGET} && \
    cargo build --release --target ${TARGET} --bin app && \
    mv /build/target/release/app /build


FROM gcr.io/distroless/cc:latest as runtime

COPY --from=builder  /build/app /app

CMD ["/app"]
