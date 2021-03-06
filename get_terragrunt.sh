#!/bin/sh

rm -rf /tmp/terragrunt
mkdir -p /tmp/terragrunt/
cp -r /terragrunt/* /tmp/terragrunt/

cd /tmp/terragrunt/

echo "Clean terragrunt"
docker kill terragrunt || true
docker rm terragrunt || true


docker run -it --rm --name terragrunt -v $HOST_MOUNT/terragrunt:/root/terragrunt -w /root/terragrunt alpine/terragrunt:0.14.8 terragrunt run-all init

