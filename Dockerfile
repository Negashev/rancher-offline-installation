FROM docker
ENV DOCKER_VERSION=19.03.9 \
    DOCKER_ARCH=x86_64 \
    INSTALL_SH_URL=https://raw.githubusercontent.com/Jrohy/docker-install/master/install.sh \
    INSTALL_BASH_URL=https://raw.githubusercontent.com/Jrohy/docker-install/master/docker.bash \
    RANCHER_VERSION=v2.5.5 \
    HELM_VERSION=3.4.1 \
    KUBECTL_VERSION=1.19.7 \
    CERT_MANAGER_VERSION=v1.0.4 \
    ROOK_VERSION=v1.0.4 \
    CEPH_VERSION=v15.2.8-20201217 \
    RKE_TOOLS_VERSION=v0.1.69 \
    HUPERKUBE_VERSION=v1.19.7-rancher1

ADD get_docker.sh /get_docker.sh
ADD get_helm.sh /get_helm.sh
ADD prepare_offline_images.sh /prepare_offline_images.sh

ADD prepeare_online.sh /prepeare_online.sh
ADD Dockerfile.bastion /Dockerfile.bastion
VOLUME [ "/hostfs" ]
CMD [ "sh", "prepeare_online.sh" ]