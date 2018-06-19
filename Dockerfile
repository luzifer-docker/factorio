FROM debian:stretch

ENV FACTORIO_SERVER_VERSION=0.16.51 \
    DUMB_INIT_VERSION=1.2.1 \
    GOSU_VERSION=1.10

RUN set -ex \
 && apt-get update \
 && apt-get install --no-install-recommends -y \
      ca-certificates \
      curl \
      xz-utils \
 && curl -sSfLo /usr/local/bin/dumb-init "https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64" \
 && curl -sSfLo /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
 && chmod +x \
      /usr/local/bin/dumb-init \
      /usr/local/bin/gosu \
 && mkdir -p /opt \
 && curl -sSLf "https://www.factorio.com/get-download/${FACTORIO_SERVER_VERSION}/headless/linux64" | \
      tar -C /opt -x -J \
 && useradd -d /opt/factorio -M -u 10000 factorio \
 && apt-get purge -y \
      ca-certificates \
      curl \
      xz-utils \
 && apt-get autoremove -y --purge \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/opt/defaults/start.sh"]
EXPOSE 34197/udp

COPY . /opt/defaults

VOLUME /data
WORKDIR /data
