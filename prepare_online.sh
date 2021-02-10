#!/bin/sh
apk add --update bash grep

sh /prepare_rancher_images.sh
cp /tmp/rancher/rancher-images.txt /tmp/rancher/offline-images.txt

echo "install helm repos"
sh /get_helm.sh

echo bastion-static >> /tmp/rancher/offline-images.txt

echo "add rke and huperkube versions"
echo rancher/rke-tools:$RKE_TOOLS_VERSION >> /tmp/rancher/offline-images.txt
echo rancher/hyperkube:$HUPERKUBE_VERSION >> /tmp/rancher/offline-images.txt
echo "add helm chartmuseum"
echo chartmuseum/chartmuseum:$CHARTMUSEAM_VERSION >> /tmp/rancher/offline-images.txt

echo "remove dublicate from offline-images.txt"
sort /tmp/rancher/offline-images.txt | uniq -u | tee /tmp/rancher/offline-images.txt

echo "install docker"
sh /get_docker.sh
docker build -t bastion-static -f /Dockerfile.bastion /tmp/docker

docker save registry:2 | gzip --stdout > /tmp/registry2.tar.gz

cat /tmp/rancher/offline-images.txt
#bash /tmp/rancher/rancher-save-images.sh --image-list /tmp/rancher/offline-images.txt --images /tmp/rancher/rancher-images.tar.gz
# scp /tmp/registry2.tar.gz to bastion
# scp /tmp/rancher/offline-images.txt to bastion
# scp /tmp/rancher/rancher-images.tar.gz to bastion
# scp /tmp/helm/*.tgz to bastion /charts/