FROM ubuntu:16.04

ARG PUID
ENV PUID=${PUID:-1000}

ARG PGID
ENV PGID=${PGID:-1000}

ARG DATADIR
ENV DATADIR ${DATADIR:-/data}

ENV YOCTO_ENTRYPOINT ${YOCTO_ENTRYPOINT:-/yocto-entrypoint.sh}

# Install packages to build yocto and ostree packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get clean && apt-get update && apt-get install -y locales \
    && apt-get -q -y install \
        nano gawk wget git-core diffstat unzip texinfo gcc-multilib g++-multilib \
        build-essential chrpath socat libsdl1.2-dev xterm \
        bc cpio curl iputils-ping python3 python3-gi sudo dosfstools sshpass \
        e2fslibs-dev libgpgme11-dev \
        libarchive-dev libattr1-dev libcap-dev libfuse-dev libgirepository1.0-dev \
        libsoup2.4-dev autoconf bison libtool liblzma-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Compile and install 'OSTree' and 'repo'
WORKDIR /home/
ENV OSTREE_VERSION v2018.9
RUN git clone git://github.com/ostreedev/ostree.git;branch=master \
    && (cd ostree \
        && git checkout $OSTREE_VERSION \
        && ./autogen.sh --prefix=/usr \
        && make -j $(nproc) \
        && make install) \
    # Install OSTree-push
    && curl -SL https://github.com/FullMetalUpdate/ostree-push/archive/v1.0.tar.gz -o ostree-push.tgz \
    && tar -xvzf ostree-push.tgz \
    && (cd ./ostree-push-1.0 \
        && make install) \
    # Install repo tool
    && locale-gen en_US.UTF-8 \
    && curl http://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
    && chmod a+x /usr/local/bin/repo

# Set-up the docker account
RUN groupadd -r docker -g ${PGID} \
    && useradd -u ${PUID} -r -g docker -d /home/docker docker \
    && mkdir /home/docker \
    && chown -R docker:docker /home/docker

RUN echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

RUN mkdir -p ${DATADIR}
RUN chown -R docker.docker ${DATADIR}

RUN mkdir -p /home/docker/.ssh \
    && chmod 700 /home/docker/.ssh

COPY ./ssh_config /home/docker/.ssh/config

RUN chmod 600 /home/docker/.ssh/config \
    && chown -R docker.docker /home/docker/.ssh

USER docker

WORKDIR /home/docker

VOLUME ["${DATADIR}"]

# Set-up the entry point of the container

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
