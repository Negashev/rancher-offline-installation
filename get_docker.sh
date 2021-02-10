#!/bin/sh
mkdir -p /tmp/docker/
wget -O /tmp/docker/install.sh $INSTALL_SH_URL
wget -O /tmp/docker/docker.bash $INSTALL_BASH_URL
wget -O /tmp/docker/docker.tgz "https://download.docker.com/linux/static/stable/$DOCKER_ARCH/docker-$DOCKER_VERSION.tgz"
chmod 777 -R /tmp/docker/