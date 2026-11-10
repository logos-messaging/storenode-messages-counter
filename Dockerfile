FROM golang:1.26-trixie AS builder

WORKDIR /src

# Cache module downloads separately from source changes
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN make

FROM debian:13-slim

ARG commit=unknown

LABEL maintainer="richard@status.im"
LABEL source="https://github.com/logos-messaging/storenode-messages-counter"
LABEL description="Storenode message count verifier"
LABEL commit="${commit}"

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && useradd --system --uid 10001 --no-create-home --shell /usr/sbin/nologin storemsgcounter

COPY --from=builder /src/build/storemsgcounter /usr/local/bin/storemsgcounter

USER storemsgcounter

ENTRYPOINT ["/usr/local/bin/storemsgcounter"]
CMD ["-help"]
