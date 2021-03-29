FROM ubuntu:18.04

ARG PUID
ENV PUID=${PUID:-1000}

ARG PGID
ENV PGID=${PGID:-1000}

ARG DATADIR
ENV DATADIR ${DATADIR:-/data}

ENV YOCTO_ENTRYPOINT ${YOCTO_ENTRYPOINT:-/yocto-entrypoint.sh}

# Avoid blocking on tzdata configuration step
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install packages to build yocto and ostree packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get clean && apt-get update && apt-get install -y locales \
    && apt-get -q -y install \
        gawk wget git-core diffstat unzip texinfo gcc-multilib \
        build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
        xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
        pylint3 xterm \
        \
        g++-multilib bc curl python3-gi sudo dosfstools sshpass \
        libarchive-dev libattr1-dev libcap-dev libfuse-dev libgirepository1.0-dev \
        libsoup2.4-dev autoconf bison libtool liblzma-dev e2fslibs-dev libgpgme-dev \
        nano vim tmux libncurses5-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Workaround to solve issue about _sysconfigdata module not found
RUN ln -s /usr/lib/python3.6/_sysconfigdata_m_linux_x86_64-linux-gnu.py /usr/lib/python3.6/_sysconfigdata.py

# Configure tmux to allow scrolling
RUN echo "set -g mouse on" > /etc/tmux.conf

# Install azcopy to push data to Azure Cloud
RUN mkdir /azcopy \
    && cd /azcopy \
    && wget https://aka.ms/downloadazcopy-v10-linux \
    && tar -xvf downloadazcopy-v10-linux \
    && cp /azcopy/azcopy_linux_amd64*/azcopy /usr/bin \
    && chmod a+x /usr/bin/azcopy \
    && cd - \
    && rm -rf /azcopy

# Compile and install 'OSTree' and 'repo'
WORKDIR /home/
ENV OSTREE_VERSION v2020.8
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
