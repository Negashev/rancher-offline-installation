#!/bin/sh

echo "Clean helm"
docker kill helm || true
docker rm helm || true

docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION repo add jetstack https://charts.jetstack.io
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION repo add rancher-stable https://releases.rancher.com/server-charts/stable
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION repo add rook-release https://charts.rook.io/release
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION repo add nvidia https://nvidia.github.io/k8s-device-plugin
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION repo add postgres-operator "https://raw.githubusercontent.com/zalando/postgres-operator/$POSTGRES_OPERATOR_VERSION/charts/postgres-operator/"
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION repo update

echo "create local rancher-$RANCHER_VERSION.tgz, cert-manager-$CERT_MANAGER_VERSION.tgz, nvidia-device-plugin-$NVIDIA_VERSION.tgz, postgres-operator-$POSTGRES_OPERATOR_VERSION.tgz and rook-ceph-$ROOK_VERSION.tgz"
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION fetch jetstack/cert-manager --version $CERT_MANAGER_VERSION
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION fetch rancher-stable/rancher --version $RANCHER_VERSION
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION fetch rook-release/rook-ceph --version $ROOK_VERSION
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION fetch nvidia/nvidia-device-plugin --version $NVIDIA_VERSION
docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION fetch postgres-operator/postgres-operator --version $POSTGRES_OPERATOR_VERSION

echo "save images from rancher-$RANCHER_VERSION.tgz, cert-manager-$CERT_MANAGER_VERSION.tgz, nvidia-device-plugin-$NVIDIA_VERSION.tgz, postgres-operator-$POSTGRES_OPERATOR_VERSION.tgz and rook-ceph-$ROOK_VERSION.tgz"
for i in `ls /tmp/helm`; do docker run --rm -it --name helm -v $HOST_MOUNT/helm:/root/ -w /root/ alpine/helm:$HELM_VERSION template ./$i | grep -oP '(?<=image: ").*(?=")' | tr -d '"' >> /tmp/rancher/offline-images.txt; done
