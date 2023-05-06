# syntax=docker/dockerfile:1.4

FROM rust:1.68.0 AS chef

WORKDIR /build

COPY . .

RUN cargo build --release  --bin  rust-docker-demo && \
    mv /build/target/release/rust-docker-demo /build

FROM gcr.io/distroless/cc:latest as runtime

COPY --from=chef  /build/rust-docker-demo /rust-docker-demo

CMD ["/rust-docker-demo"]
