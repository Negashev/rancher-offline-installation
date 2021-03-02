#!/bin/bash
cd /tmp
wget $BASTION_HOST/install.sh
wget $BASTION_HOST/docker.bash
wget $BASTION_HOST/daemon.json
wget $BASTION_HOST/docker-$DOCKER_VERSION.tgz
sudo mkdir -p /etc/docker
sudo cp /tmp/daemon.json /etc/docker/daemon.json
bash /tmp/install.sh -f /tmp/docker-$DOCKER_VERSION.tgz
