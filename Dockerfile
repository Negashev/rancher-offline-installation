FROM docker
ENV DOCKER_VERSION=19.03.15 \
    DOCKER_ARCH=x86_64 \
    RANCHER_VERSION=v2.5.6 \
    HELM_VERSION=3.4.1 \
    KUBECTL_VERSION=1.19.7 \
    METALLLB_VERSION=2.3.5 \ 
    INGRESS_VERSION=3.29.0 \
    CERT_MANAGER_VERSION=v1.0.4 \
    ROOK_VERSION=v1.5.8 \
    CEPH_VERSION=v15.2.9-20210224 \
    RKE_TOOLS_VERSION=v0.1.72 \
    HUPERKUBE_VERSION=v1.20.4-rancher1 \ 
    CHARTMUSEAM_VERSION=v0.12.0 \ 
    NVIDIA_VERSION=0.8.1 \
    POSTGRES_OPERATOR_VERSION=v1.6.1 \
    POSTGRES_IMAGE=registry.opensource.zalan.do/acid/spilo-13:2.0-p4 \
    HOSTS_RANCHER_CLUSTER='["0.0.0.1","0.0.0.2","0.0.0.3"]' \
    HOSTS_CLUSTER_MAP='{"brain":["0.0.0.4","0.0.0.5","0.0.0.6"],"storage":{"0.0.0.7":"10.10.10.7","0.0.0.8":"10.10.10.8","0.0.0.9":"10.10.10.9"},"worker":["0.0.0.10","0.0.0.11","0.0.0.12"]}' \
    RANCHER_HOSTNAME=my.company.com \
    RANCHER_PASSWORD=passw0rd \
    HOST_MOUNT=/tmp \ 
    BASTION_HOST=0.0.0.0 \
    BASTION_USER=user \
    BASTION_SCP='sshpass -p "passw0rd" scp -r {source} {user}@{host}:{destination}' \
    BASTION_SSH_RUN='echo "passw0rd" | sshpass ssh -p "passw0rd" -oStrictHostKeyChecking=no -oPasswordAuthentication=yes {user}@{host}' \
    BASTION_DIR=\/var\/offline

COPY get_docker.sh /get_docker.sh
COPY get_helm.sh /get_helm.sh
COPY get_terragrunt.sh /get_terragrunt.sh
COPY prepare_rancher_images.sh /prepare_rancher_images.sh
COPY install_docker.sh /install_docker.sh
COPY install_docker_binary.sh /install_docker_binary.sh

COPY Dockerfile.bastion /Dockerfile.bastion
COPY Dockerfile.terragrunt /Dockerfile.terragrunt
COPY prepare_online.sh /prepare_online.sh
RUN chmod +x /prepare_online.sh
ENTRYPOINT [ "/prepare_online.sh" ]

COPY /terragrunt /terragrunt
