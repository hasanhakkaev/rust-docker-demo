# syntax=docker/dockerfile:1.4

FROM rust:1.68.2 as builder

ARG TARGET

WORKDIR /build

COPY . .

RUN echo "Building for $TARGET"
RUN --mount=type=cache,target=/usr/local/cargo/registry,id=${TARGETPLATFORM} --mount=type=cache,target=/build/target,id=${TARGETPLATFORM} \
    rustup target add ${TARGET} && \
    cargo build --release --target ${TARGET} --bin  rust-docker-demo && \
    mv /build/target/release/${TARGET}/rust-docker-demo /build


FROM gcr.io/distroless/cc:latest as runtime

COPY --from=builder  /build/rust-docker-demo /rust-docker-demo

CMD ["/rust-docker-demo"]
