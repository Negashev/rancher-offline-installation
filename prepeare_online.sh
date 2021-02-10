#!/bin/sh
sh /get_docker.sh
#cp /Dockerfile.bastion /hostfs/tmp/docker/Dockerfile.bastion

docker build -t bastion-static -f /Dockerfile.bastion /hostfs/tmp/docker/
