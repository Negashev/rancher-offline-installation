#!/bin/sh

rm -rf /tmp/terragrunt
mkdir -p /tmp/terragrunt/
cp -r /terragrunt/* /tmp/terragrunt/

cd /tmp/terragrunt/

echo "Clean terragrunt"
docker kill terragrunt || true
docker rm terragrunt || true


docker run -it --name terragrunt -v $HOST_MOUNT/terragrunt:/root/terragrunt -w /root/terragrunt alpine/terragrunt terragrunt run-all init

