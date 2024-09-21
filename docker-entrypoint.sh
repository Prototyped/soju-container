#!/bin/sh

set -eux

if ! su - -c '[ -r /etc/ssl/certs/soju/fullchain.pem ] && [ -r /etc/ssl/certs/soju/privkey.pem ]' soju
then
    echo Cannot find Soju certificate and/or key. 1>&2
    set +e
    su - -c 'ls -lRa /etc/ssl/certs/soju /etc/ssl/archive 1>&2' soju
    set -e
    sleep 60
    exit 1
fi

cp /etc/soju/config.no-hostname /etc/soju/config
echo hostname $(hostname --fqdn) >> /etc/soju/config
exec su - -c 'exec soju -config /etc/soju/config' soju
