#!/bin/sh

docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION repo add jetstack https://charts.jetstack.io
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION repo add rancher-stable https://releases.rancher.com/server-charts/stable
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION repo add rook-release https://charts.rook.io/release
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION repo update

echo "create local cert-manager-$CERT_MANAGER_VERSION.tgz and rook-ceph-$ROOK_VERSION.tgz"
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION fetch jetstack/cert-manager --version $CERT_MANAGER_VERSION
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION fetch rancher-stable/rancher --version $RANCHER_VERSION
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION fetch rook-release/rook-ceph --version $ROOK_VERSION

echo "save images from cert-manager-$CERT_MANAGER_VERSION.tgz and rook-ceph-$ROOK_VERSION.tgz"
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION template ./cert-manager-$CERT_MANAGER_VERSION.tgz | grep -oP '(?<=image: ").*(?=")' >> /tmp/rancher/offline-images.txt
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION template ./rook-ceph-$ROOK_VERSION.tgz | grep -oP '(?<=image: ").*(?=")' >> /tmp/rancher/offline-images.txt