FROM docker
ENV DOCKER_VERSION=19.03.9 \
    DOCKER_ARCH=x86_64 \
    INSTALL_SH_URL=https://raw.githubusercontent.com/Jrohy/docker-install/master/install.sh \
    INSTALL_BASH_URL=https://raw.githubusercontent.com/Jrohy/docker-install/master/docker.bash \
    RANCHER_VERSION=v2.5.5 \
    HELM_VERSION=3.4.1 \
    KUBECTL_VERSION=1.19.7 \
    CERT_MANAGER_VERSION=v1.0.4 \
    ROOK_VERSION=v1.5.6 \
    CEPH_VERSION=v15.2.8-20201217 \
    RKE_TOOLS_VERSION=v0.1.69 \
    HUPERKUBE_VERSION=v1.19.7-rancher1 \ 
    CHARTMUSEAM_VERSION=v0.12.0 \ 
    NVIDIA_VERSION=0.8.1 \
    POSTGRES_OPERATOR_VERSION=v1.6.0 \
    POSTGRES_IMAGE=registry.opensource.zalan.do/acid/spilo-13:2.0-p2 \
    HOST_MOUNT=/tmp \ 
    BASTION_HOST=0.0.0.0 \
    BASTION_USER=user \
    BASTION_SCP='sshpass -p "passw0rd" scp -r {source} {user}@{host}:{destination}' \
    BASTION_SSH_RUN='echo "passw0rd" | sshpass ssh -p "passw0rd" -oStrictHostKeyChecking=no -oPasswordAuthentication=yes {user}@{host}' \
    BASTION_DIR=\/var\/offline

ADD get_docker.sh /get_docker.sh
ADD get_helm.sh /get_helm.sh
ADD prepare_rancher_images.sh /prepare_rancher_images.sh
ADD install_docker.sh /install_docker.sh

ADD Dockerfile.bastion /Dockerfile.bastion
ADD prepare_online.sh /prepare_online.sh
RUN chmod +x /prepare_online.sh
ENTRYPOINT [ "/prepare_online.sh" ]