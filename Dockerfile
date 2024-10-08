FROM --platform=linux/arm64/v8 docker.io/arm64v8/debian:trixie-slim AS trixie

RUN set -ex; \
    DEBIAN_FRONTEND=noninteractive; \
    export DEBIAN_FRONTEND; \
    apt -y update; \
    apt -y install --no-install-recommends ca-certificates lz4; \
    apt -y dist-upgrade; \
    apt -y autoremove; \
    apt -y clean; \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN set -ex; \
    DEBIAN_FRONTEND=noninteractive; \
    export DEBIAN_FRONTEND; \
    apt -y update; \
    apt -y install tini soju; \
    apt -y clean; \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*; \
    usermod -s /bin/sh -c Soju -U soju; \
    mkdir -p /var/lib/soju/logs /etc/ssl/certs/soju /etc/ssl/archive /home/soju/uploads /etc/soju /run/soju; \
    chown -R soju:soju /etc/ssl/certs/soju /etc/ssl/archive /home/soju/uploads /run/soju

VOLUME /var/lib/soju
VOLUME /etc/ssl/certs/soju
VOLUME /etc/ssl/archive
VOLUME /home/soju/uploads

COPY --chmod=0755 docker-entrypoint.sh /docker-entrypoint.sh
COPY --chown=soju:soju config /etc/soju/config.no-hostname

ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]
