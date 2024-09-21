#!/bin/sh

set -eux

if ! [ -r /etc/ssl/certs/soju/fullchain.pem ] || ! [ -r /etc/ssl/certs/soju/privkey.pem ]
then
    echo Cannot find Soju certificate and/or key. 1>&2
    ls -lRa /etc/ssl/certs/soju /etc/ssl/archive 1>&2
    exit 1
fi

cp /etc/soju/config.no-hostname /etc/soju/config
echo hostname $(hostname --fqdn) >> /etc/soju/config
exec su - -c 'exec soju -config /etc/soju/config' soju
