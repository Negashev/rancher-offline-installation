On machine with internet access
```
sudo docker build -t online https://github.com/Negashev/rancher-offline-installation.git#main && sudo docker run -it --rm -v /var/run:/var/run -v /tmp:/tmp --privileged online
```