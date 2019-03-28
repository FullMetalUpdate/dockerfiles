FROM openjdk:8u201-jre-alpine

MAINTAINER Cedric Vincent <cvincent@witekio.com>

ENV HAWKBIT_VERSION=0.3.0M1 \
    HAWKBIT_HOME=/opt/hawkbit \
    JAR_FILE=hawkbit-update-server.jar

EXPOSE 8080

######### General install
RUN set -x \
    && apk add --no-cache gnupg unzip \
    && apk add --no-cache libressl wget \
    && apk add --no-cache git openjdk8 maven python2

RUN mkdir -p $HAWKBIT_HOME \
    && cd $HAWKBIT_HOME

######### Hawkbit
RUN git clone https://github.com/eclipse/hawkbit.git -b $HAWKBIT_VERSION

######### Add mysql dependency
COPY add_mysql.py /hawkbit/hawkbit-repository/hawkbit-repository-jpa/add_mysql.py
RUN cd /hawkbit/hawkbit-repository/hawkbit-repository-jpa/ \
    && ./add_mysql.py \
    && cd -

######### Enable CORS support in Hawkbit
COPY patch_cors_hawkbit.patch /hawkbit/
RUN cd /hawkbit/ \
    && dos2unix patch_cors_hawkbit.patch \
    && git apply --ignore-whitespace patch_cors_hawkbit.patch \
    && cd -

RUN cd hawkbit \
    && mvn install

RUN cp /hawkbit/hawkbit-runtime/hawkbit-update-server/target/hawkbit-update-server-0.3.0-SNAPSHOT.jar $HAWKBIT_HOME/hawkbit-update-server.jar

VOLUME "$HAWKBIT_HOME/data"

COPY application.properties $HAWKBIT_HOME

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

WORKDIR $HAWKBIT_HOME

ENTRYPOINT ["/entrypoint.sh"]
