On machine with internet access

You need
- vm with internet and bastion access
- docker on this vm
- 60Gb+ on vm and bastion
```
sudo docker build -t online https://github.com/Negashev/rancher-offline-installation.git#main && sudo docker run -it --rm -v /var/run:/var/run -v /tmp:/tmp --privileged online -b -o -p -i
```
```
Usage:
    -o creating data on local with internet
    -i creating tar.gz from offline-images.txt
    -b Upload data to bastion server  by $BASTION_SCP
    -p Start instalation on bastion $BASTION_HOST
```
