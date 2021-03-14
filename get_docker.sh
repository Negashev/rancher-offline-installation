#!/bin/sh
mkdir -p /tmp/docker/
cd /tmp/docker/
wget "https://download.docker.com/linux/static/stable/$DOCKER_ARCH/docker-$DOCKER_VERSION.tgz"
chmod 777 -R /tmp/docker/
