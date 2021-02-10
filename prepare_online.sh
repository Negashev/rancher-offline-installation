#!/bin/sh
apk add --update bash grep

while getopts ":ib" opt; do
  case ${opt} in
    i ) create_tar=true
      ;;
    b ) upload_to_bastion=true
      ;;
    \? )
      echo "Usage:"
      echo "    -i Skip creating tar.gz from offline-images.txt"
      echo "    -b Upload data to bastion server by \$SCP_TO_BASTION"
      exit 0
      ;;
  esac
done

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

docker save registry:2 > /tmp/registry2.tar

cat /tmp/rancher/offline-images.txt

if test -z "$create_tar"
then
      echo "SKIP creating tar.gz from offline-images.txt"
else
      echo "Creating tar.gz from offline-images.txt"
      bash /tmp/rancher/rancher-save-images.sh --image-list /tmp/rancher/offline-images.txt --images /tmp/rancher/rancher-images.tar.gz
fi

if test -z "$upload_to_bastion"
then
      echo "SKIP Upload to bastion"
else
      echo "Upload to bastion"
      # scp /tmp/registry2.tar to bastion
      # scp /tmp/rancher/offline-images.txt to bastion
      # scp /tmp/rancher/rancher-images.tar.gz to bastion
      # scp /tmp/helm/*.tgz to bastion /charts/
fi