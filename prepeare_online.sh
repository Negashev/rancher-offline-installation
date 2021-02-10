#!/bin/sh
apk add --update bash grep

sh /prepare_offline_images.sh

sh /get_docker.sh
docker build -t bastion-static -f /Dockerfile.bastion /tmp/docker
echo bastion-static >> /tmp/rancher/rancher-images.txt

sh /get_helm.sh