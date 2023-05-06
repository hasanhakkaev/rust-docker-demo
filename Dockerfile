# syntax=docker/dockerfile:1.4

FROM lukemathwalker/cargo-chef:latest-rust-1.68.0 AS chef

#ARG TARGET

WORKDIR /build

COPY . .

RUN cargo chef prepare --recipe-path recipe.json

RUN cargo chef cook --release --recipe-path recipe.json

RUN cargo build --release  --bin  rust-docker-demo && \
    mv /build/target/release/rust-docker-demo /build


FROM gcr.io/distroless/cc:latest as runtime

COPY --from=chef  /build/rust-docker-demo /rust-docker-demo

CMD ["/rust-docker-demo"]
