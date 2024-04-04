#!/bin/bash

PORTDIR=$(pwd)

if [ ! -d $PORTDIR/certs ] ; then
    echo -n "Creating self-signed certificates for portainer... "
    mkdir certs
    cd certs
    openssl genrsa -out cert.key 4096 > /dev/null
    openssl req -new -key cert.key -out cert.csr -subj '/' > /dev/null
    openssl x509 -req -days 3650 -in cert.csr -signkey cert.key -out cert.crt > /dev/null 2> /dev/null
    cd -
    echo " OK"
fi

if [[ "$(which docker)" == "" ]] ; then
    echo -n "Installing docker ..."
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
        apt-get remove -yq $pkg > /dev/null
    done
    apt-get -yqq update
    apt-get -yqq install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get -yqq update
    apt-get -yqq install docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
    echo " OK !"
fi


docker run \
        -d \
        -p 9000:9443 \
        --name portainer \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $PORTDIR:/data \
        -v $PORTDIR/certs:/certs \
        portainer/portainer-ce:2.19.4-alpine \
        --ssl \
        --sslcert /certs/cert.crt \
        --sslkey /certs/cert.key 

