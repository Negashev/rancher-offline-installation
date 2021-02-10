#!/bin/sh

docker run --rm -it --name helm -v /tmp/helm:/root/ alpine/helm:$HELM_VERSION repo add jetstack https://charts.jetstack.io
docker run --rm -it --name helm -v /tmp/helm:/root/ alpine/helm:$HELM_VERSION repo add rancher-stable https://releases.rancher.com/server-charts/stable
docker run --rm -it --name helm -v /tmp/helm:/root/ alpine/helm:$HELM_VERSION repo add rook-release https://charts.rook.io/release
docker run --rm -it --name helm -v /tmp/helm:/root/ alpine/helm:$HELM_VERSION repo update

docker run --rm -it --name helm -v /tmp/helm:/root/ alpine/helm:$HELM_VERSION fetch jetstack/cert-manager --version $CERT_MANAGER_VERSION
docker run --rm -it --name helm -v /tmp/helm:/root/ alpine/helm:$HELM_VERSION fetch rook-release/rook-ceph --version $ROOK_VERSION

docker run --rm -it --name helm -v /tmp/helm:/root/ alpine/helm:$HELM_VERSION template ./cert-manager-$CERT_MANAGER_VERSION.tgz | grep -oP '(?<=image: ").*(?=")' >> ./rancher-images.txt
docker run --rm -it --name helm -v /tmp/helm:/root/ alpine/helm:$HELM_VERSION template ./rook-ceph-$ROOK_VERSION.tgz | grep -oP '(?<=image: ").*(?=")' >> ./rancher-images.txt