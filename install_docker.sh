#!/bin/bash
cd /tmp
wget $BASTION_HOST/install_docker_binary.sh
wget $BASTION_HOST/daemon.json
wget $BASTION_HOST/docker-$DOCKER_VERSION.tgz
sudo mkdir -p /etc/docker
sudo cp /tmp/daemon.json /etc/docker/daemon.json
bash /tmp/install_docker_binary.sh /tmp/docker-$DOCKER_VERSION.tgz
