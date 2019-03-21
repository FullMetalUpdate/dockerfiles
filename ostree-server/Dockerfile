FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get clean && apt-get update && apt-get install -y locales \
    && apt-get -q -y install \
        ostree curl python3 git make python3-gi python3-pip gir1.2-ostree-1.0\
        openssh-server\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

RUN locale-gen en_US.UTF-8

#RUN pip3 install ptvsd

RUN mkdir /var/run/sshd
RUN mkdir /root/.sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i -e 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN git clone https://github.com/fullmetalupdate/ostree-push/ \
&& cd ostree-push \
&& make install

ARG DATADIR
ENV DATADIR ${DATADIR:-/data}

VOLUME ["${DATADIR}"]

EXPOSE 22
EXPOSE 8000

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
