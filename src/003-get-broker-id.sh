#!/bin/bash

# first grab the last broker id
BROKER_ID=$(cat /kafka/meta.properties | grep -o "broker\.id=.*" | sed -r "s/broker\.id=(.*)/\1/g")

if [[ -z "$BROKER_ID" ]]; then
    # if it doesn't exist, grab a new ID from zookeeper using atomic increment
    export BROKER_ID=$(zookeepercli --server $KAFKA_ZOOKEEPER_CONNECT -c inc /kafka-broker-atom)
fi

echo $BROKER_ID