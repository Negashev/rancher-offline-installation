#!/bin/sh
sh /get_docker.sh
# sh /prepare_offline_images.sh
sh /get_helm.sh

docker build -t bastion-static -f /Dockerfile.bastion /tmp/docker
