You need
- vm with internet and bastion access
- docker on this vm
- 60Gb+ on vm and bastion

![rancher-offline-installation](rancher-offline-installation.jpg)


```
Usage:
    -o creating data on local with internet
    -i creating tar.gz from offline-images.txt
    -b Upload data to bastion server  by $BASTION_SCP
    -p Start instalation on bastion $BASTION_HOST
```


### Docs
---

#### Preapare ADMIN
- install docker on VM with internet (next ADMIN vm)
```
curl https://releases.rancher.com/install-docker/19.03.sh | sh
```
- on ADMIN should be with access to offline bastion
```
HOST_MOUNT      # dir on admin for store everything 60G+
BASTION_HOST    # bastion ip (admin got access to bastion)
BASTION_USER    # bastion user to scp install docker
BASTION_SCP     # scp command with '{source} {user}@{host}:{destination}' to SCP data from admin to bastion
BASTION_SSH_RUN # exec command with '{user}@{host}' from admin to bastion
```
```
sudo docker build -t online git@github.com:amttel/rancher-offline.git#main && \
sudo docker run -it --rm \
-v /var/run:/var/run \
-v /var/online_bastion:/tmp \
-e HOST_MOUNT=/var/online_bastion \
-e BASTION_HOST=10.0.10.10 \
-e BASTION_USER=username \
-e BASTION_SCP='sshpass -p "passw0rd" scp -oStrictHostKeyChecking=no -r {source} {user}@{host}:{destination}' \
-e BASTION_SSH_RUN='echo "passw0rd" | sshpass -p "passw0rd" ssh -oStrictHostKeyChecking=no  -oPasswordAuthentication=yes {user}@{host}' \
--privileged \
online -b -o -p -i
```
---
#### Check the bastion
- on bastion `docker ps` show 3 containers
```
registry
bastion-static
chartmuseum
```
---
#### Start offline installation (from bastion)
- on bastion, cp terragrunt data
```
# store all terragrunt data on bastion
sudo docker run -it --rm -v /var/terragrunt:/mount -w /terragrunt terragrunt cp -r ./ /mount/
```
- on bastion, provision all nodes offline
```
TF_VAR_bastion_host      # bastion host for all nodes to install docker, rancher agent, and use for insecure docker registry
TF_VAR_ssh_password      # ssh password from bastion user on all nodes
TF_VAR_ssh_user          # ssh user from bastion on all nodes
TF_VAR_rancher_nodes     # array of ip's for rancher (Kubernetes by rke)
TF_VAR_rancher_hostname  # rancher domain for cluster's
TF_VAR_rancher_password  # rancher admin password
TF_VAR_cluster_nodes     # dict(array) keys of brain, storage and worker nodes of user cluster
TF_VAR_public_network    # frontend range for ceph
TF_VAR_cluster_network   # backend range for ceph
TF_VAR_data_devices_size # ceph data
TF_VAR_wal_devices_size  # ceph wal, can be null
TF_VAR_db_devices_size   # ceph db, can be null
TF_VAR_network_plugin    # cluster rke network plugin
TF_VAR_metallb_addresses # metallb ip range 
```
```
sudo docker run -it --rm -v /var/terragrunt:/mount -w /mount terragrunt \
-e TF_VAR_bastion_host=10.10.10.10 \
-e TF_VAR_ssh_password=passw0rd \
-e TF_VAR_ssh_user=username \
-e TF_VAR_rancher_nodes='["0.0.0.1","0.0.0.2","0.0.0.3"]' \
-e TF_VAR_rancher_hostname=my.company.com \
-e TF_VAR_rancher_password=Rancher-passw0rd \
-e TF_VAR_cluster_nodes='{"brain":["0.0.0.4","0.0.0.5","0.0.0.6"],"storage":["0.0.0.7","0.0.0.8","0.0.0.9"],"worker":["0.0.0.10","0.0.0.11","0.0.0.12"]}' \
-e TF_VAR_public_network='0.0.0.0/23' \
-e TF_VAR_cluster_network='0.0.1.0/23' \
-e TF_VAR_data_devices_size='1TB:' \
-e TF_VAR_wal_devices_size='10G:15G' \
-e TF_VAR_db_devices_size='200G:300G' \
-e TF_VAR_network_plugin=canal \
-e TF_VAR_metallb_addresses='10.0.0.100-10.0.0.110' \
terragrunt run-all apply
