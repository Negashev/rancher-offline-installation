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

echo "add rke, huperkube and ceph versions"
echo rancher/rke-tools:$RKE_TOOLS_VERSION >> /tmp/rancher/offline-images.txt
echo rancher/hyperkube:$HUPERKUBE_VERSION >> /tmp/rancher/offline-images.txt
echo ceph/ceph:$CEPH_VERSION >> /tmp/rancher/offline-images.txt
echo "add helm chartmuseum"
echo chartmuseum/chartmuseum:$CHARTMUSEAM_VERSION >> /tmp/rancher/offline-images.txt

echo "remove dublicate from offline-images.txt"
sort /tmp/rancher/offline-images.txt | uniq -u | tee /tmp/rancher/offline.txt

echo "install docker"
sh /get_docker.sh
docker build --build-arg DOCKER_VERSION=$DOCKER_VERSION -t bastion-static -f /Dockerfile.bastion /tmp/docker

docker save registry:2 > /tmp/registry2.tar

cat /tmp/rancher/offline.txt

if test -z "$create_tar"
then
      echo "SKIP creating tar.gz from offline-images.txt"
else
      echo "Creating tar.gz from offline-images.txt"
      bash /tmp/rancher/rancher-save-images.sh --image-list /tmp/rancher/offline.txt --images /tmp/rancher/rancher-images.tar.gz
fi

if test -z "$upload_to_bastion"
then
      echo "SKIP Upload to bastion"
else
      echo "Upload to bastion"
      echo "scp /tmp/registry2.tar to bastion"
      `echo $SCP_BASTION | sed -r 's/\{source\}/\/tmp\/registry2.tar/g' |  sed -r "s/\{destination\}/$BASTION_DIR\/registry2.tar/g"`
      echo "scp /tmp/rancher/offline-images.txt to bastion"
      `echo $SCP_BASTION | sed -r 's/\{source\}/\/tmp\/rancher\/offline-images.txt/g' |  sed -r "s/\{destination\}/$BASTION_DIR\/offline-images.txt/g"`
      echo "scp /tmp/rancher/rancher-images.tar.gz to bastion"
      `echo $SCP_BASTION | sed -r 's/\{source\}/\/tmp\/rancher\/rancher-images.tar.gz/g' |  sed -r "s/\{destination\}/$BASTION_DIR\/rancher-images.tar.gz/g"`
      echo "scp /tmp/helm/ to bastion"
      `echo $SCP_BASTION | sed -r 's/\{source\}/\/tmp\/helm/g' |  sed -r "s/\{destination\}/$BASTION_DIR\/charts/g"`
fi