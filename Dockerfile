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
    HUPERKUBE_VERSION=v1.19.7-rancher1\ 
    CHARTMUSEAM_VERSION=v0.12.0

ADD get_docker.sh /get_docker.sh
ADD get_helm.sh /get_helm.sh
ADD prepare_rancher_images.sh /prepare_rancher_images.sh

ADD Dockerfile.bastion /Dockerfile.bastion
ADD prepare_online.sh /prepare_online.sh
RUN chmod +x /prepare_online.sh
ENTRYPOINT [ "/prepare_online.sh" ]