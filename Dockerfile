FROM debian

ENV FACTORIO_SERVER_VERSION 0.15.33

ENTRYPOINT ["/opt/defaults/start.sh"]
EXPOSE 34197/udp

ADD . /opt/defaults

RUN set -ex \
 && apt-get update && apt-get install -y curl xz-utils \
 && mkdir -p /opt \
 && useradd -d /opt/factorio -M -u 10000 factorio \
 && curl -sSLfo /tmp/factorio.tgz https://www.factorio.com/get-download/${FACTORIO_SERVER_VERSION}/headless/linux64 \
 && tar -C /opt -x -J -f /tmp/factorio.tgz \
 && chown -R factorio:factorio /opt/factorio \
 && rm /tmp/factorio.tgz

USER factorio

VOLUME /data
WORKDIR /data
