#!/bin/sh
apk add --update bash grep

sh /prepare_offline_images.sh

echo "install helm repos"
sh /get_helm.sh

echo bastion-static >> /tmp/rancher/rancher-images.txt

echo "add rke and huperkube versions"
docker pull rancher/rke-tools:$RKE_TOOLS_VERSION
echo rancher/rke-tools:$RKE_TOOLS_VERSION >> /tmp/rancher/rancher-images.txt
docker pull rancher/hyperkube:$HUPERKUBE_VERSION
echo rancher/hyperkube:$HUPERKUBE_VERSION >> /tmp/rancher/rancher-images.txt

echo "remove dublicate from rancher-images.txt"
sort /tmp/rancher/rancher-images.txt | uniq -u | tee /tmp/rancher/rancher-images.txt

echo "install docker"
sh /get_docker.sh
docker build -t bastion-static -f /Dockerfile.bastion /tmp/docker

cat /tmp/rancher/rancher-images.txt