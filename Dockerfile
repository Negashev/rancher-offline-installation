FROM docker
ENV DOCKER_VERSION=19.03.9 \
    ARCH=x86_64 \
    INSTALL_SH_URL=https://raw.githubusercontent.com/Jrohy/docker-install/master/install.sh \
    INSTALL_BASH_URL=https://raw.githubusercontent.com/Jrohy/docker-install/master/docker.bash
ADD get_docker.sh /get_docker.sh
ADD prepeare_online.sh /prepeare_online.sh
ADD Dockerfile.bastion /Dockerfile.bastion
VOLUME [ "/hostfs" ]
CMD [ "sh", "prepeare_online.sh" ]