# syntax=docker/dockerfile:1.4.3-labs
FROM lukemathwalker/cargo-chef:0.1.59-rust-1.69-buster AS chef

WORKDIR /build

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /build/recipe.json recipe.json

# Build dependencies - this is the caching Docker layer!
RUN cargo chef cook --release --recipe-path recipe.json

COPY . .

# Build the application
RUN cargo build --release  --bin  rust-docker-demo

FROM gcr.io/distroless/cc:latest as runtime

COPY --from=builder  /build/target/release/rust-docker-demo /rust-docker-demo

CMD ["/rust-docker-demo"]
