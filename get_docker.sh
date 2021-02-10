#!/bin/sh
mkdir -p /tmp/docker/
cd /tmp/docker/
wget $INSTALL_SH_URL
wget $INSTALL_BASH_URL
wget "https://download.docker.com/linux/static/stable/$DOCKER_ARCH/docker-$DOCKER_VERSION.tgz"
chmod 777 -R /tmp/docker/