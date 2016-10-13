FROM anapsix/alpine-java

MAINTAINER HuLiKeJi

# required dependencies
RUN apk add --update unzip wget curl docker jq coreutils

# download Kafka
ENV KAFKA_VERSION="0.10.0.1" SCALA_VERSION="2.11"
ADD src/001-download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

# setup IO volume so we connect with marathon's local persistent storage
VOLUME ["/kafka"]

# adding setup and run scripts
ADD src/002-kafka-setup.sh /usr/bin/kafka-setup.sh
ADD src/003-create-topics.sh /usr/bin/create-topics.sh
ADD src/004-start-kafka.sh /tmp/start-kafka.sh
ADD src/999-test.sh /tmp/test.sh

CMD ["/tmp/test.sh"]