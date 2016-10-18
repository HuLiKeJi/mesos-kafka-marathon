FROM anapsix/alpine-java

MAINTAINER HuLiKeJi

# required dependencies
RUN apk add --update unzip wget curl jq coreutils

# download Kafka
ENV KAFKA_VERSION="0.9.0.1" SCALA_VERSION="2.11"
ADD src/001-download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh && \
    tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && \
    rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

# zookeepercli
RUN wget -q "https://github.com/HuLiKeJi/zookeepercli/releases/download/v1.0.11/zookeepercli-linux.tgz" -O /tmp/zookeepercli.tgz && \
    tar xfz /tmp/zookeepercli.tgz -C /usr/bin && \
    chmod +x /usr/bin/zookeepercli && \
    rm /tmp/zookeepercli.tgz

# setup IO volume so we connect with marathon's local persistent storage
VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

# adding setup and run scripts
ADD src/002-kafka-setup.sh /usr/bin/kafka-setup.sh
ADD src/003-get-broker-id.sh /usr/bin/get-broker-id.sh
ADD src/004-create-topics.sh /usr/bin/create-topics.sh
ADD src/005-start-kafka.sh /usr/bin/start-kafka.sh

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]