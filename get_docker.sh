#!/bin/sh
mkdir -r /hostfs/tmp/docker/
chmod 777 -R /hostfs/tmp/docker/
wget -O /hostfs/tmp/docker/install.sh $INSTALL_SH_URL
wget -O /hostfs/tmp/docker/docker.bash $INSTALL_BASH_URL
wget -O /hostfs/tmp/docker/docker.tgz "https://download.docker.com/linux/static/stable/$ARCH/docker-$DOCKER_VERSION.tgz"
chmod 777 -R /hostfs/tmp/docker/