#!/bin/bash

###########################################################################

## these environment vars shouldn't be overridden unless you absolutely have to, since it connects with marathon config

if [[ -z "$KAFKA_PORT" ]]; then
    # make sure in Marathon json, have one port configured named "kafka"
    export KAFKA_PORT=$PORT_KAFKA
fi
if [[ -z "$KAFKA_LISTENERS" ]]; then
    # set up listeners
    export KAFKA_LISTENERS="PLAINTEXT://:$PORT_KAFKA"
fi
if [[ -z "$KAFKA_ADVERTISED_HOST_NAME" ]]; then
    # bind to the hostname Marathon provides
    export KAFKA_ADVERTISED_HOST_NAME=$HOST
fi
if [[ -z "$KAFKA_BROKER_ID" ]]; then
    # allocate task ID for broker ID
    # setting up persistent storage locks the tasks, so it is good to keep the broker id consistent
    export KAFKA_BROKER_ID=$MESOS_TASK_ID
fi
if [[ -z "$KAFKA_LOG_DIRS" ]]; then
    # write logs to the persistent storage location, which Marathon json needs to match
    export KAFKA_LOG_DIRS="/kafka"
fi

############################################################################

if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
    export KAFKA_ZOOKEEPER_CONNECT=$(env | grep ZK.*PORT_2181_TCP= | sed -e 's|.*tcp://||' | paste -sd ,)
fi

if [[ -n "$KAFKA_HEAP_OPTS" ]]; then
    sed -r -i "s/(export KAFKA_HEAP_OPTS)=\"(.*)\"/\1=\"$KAFKA_HEAP_OPTS\"/g" $KAFKA_HOME/bin/kafka-server-start.sh
    unset KAFKA_HEAP_OPTS
fi

for VAR in `env`
do
  if [[ $VAR =~ ^KAFKA_ && ! $VAR =~ ^KAFKA_HOME ]]; then
    kafka_name=`echo "$VAR" | sed -r "s/KAFKA_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
    env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
    if egrep -q "(^|^#)$kafka_name=" $KAFKA_HOME/config/server.properties; then
        sed -r -i "s@(^|^#)($kafka_name)=(.*)@\2=${!env_var}@g" $KAFKA_HOME/config/server.properties #note that no config values may contain an '@' char
    else
        echo "$kafka_name=${!env_var}" >> $KAFKA_HOME/config/server.properties
    fi
  fi
done

if [[ -n "$CUSTOM_INIT_SCRIPT" ]] ; then
  eval $CUSTOM_INIT_SCRIPT
fi
