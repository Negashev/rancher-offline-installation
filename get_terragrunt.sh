#!/bin/sh

rm -rf /tmp/terragrunt
mkdir -p /tmp/terragrunt/
cp -r /terragrunt/* /tmp/terragrunt/

cd /tmp/terragrunt/

docker kill terragrunt || true
docker rm terragrunt || true


docker run -dit --name terragrunt -v $HOST_MOUNT/terragrunt:/root/terragrunt -w /root/terragrunt --entrypoint=sh alpine/terragrunt

# download dependency
docker exec -it terragrunt terragrunt run-all init

