#!/bin/sh
mkdir -p /tmp/rancher/
cd /tmp/rancher/
wget "https://github.com/rancher/rancher/releases/download/$RANCHER_VERSION/rancher-images.txt"
wget "https://github.com/rancher/rancher/releases/download/$RANCHER_VERSION/rancher-load-images.sh"
wget "https://github.com/rancher/rancher/releases/download/$RANCHER_VERSION/rancher-save-images.sh"

bash rancher-save-images.sh