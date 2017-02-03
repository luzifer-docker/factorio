FROM debian

ENV FACTORIO_SERVER_VERSION 0.14.22

ENTRYPOINT ["/opt/defaults/start.sh"]
EXPOSE 34197/udp

ADD https://www.factorio.com/get-download/${FACTORIO_SERVER_VERSION}/headless/linux64 /tmp/factorio.tgz
ADD . /opt/defaults

RUN set -ex \
 && mkdir -p /opt \
 && useradd -d /opt/factorio -M -u 10000 factorio \
 && tar -C /opt -x -z -f /tmp/factorio.tgz \
 && chown -R factorio:factorio /opt/factorio \
 && rm /tmp/factorio.tgz

USER factorio

VOLUME /data
WORKDIR /data
