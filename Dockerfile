## Build stage
FROM rust as builder
RUN rustup toolchain add nightly
RUN rustup default nightly
RUN cargo +nightly install -f cargo-fuzz

## Add source code
ADD . /proc-macro2
WORKDIR /proc-macro2/fuzz

RUN cargo fuzz build parse_token_stream

# Package Stage
FROM ubuntu:20.04
COPY --from=builder /proc-macro2/fuzz/target/x86_64-unknown-linux-gnu/release/parse_token_stream /
