#!/bin/sh

echo "list marathon variables"
echo $PORTS
echo $PORT0
echo $PORT1
echo $MARATHON_APP_ID
echo $MARATHON_APP_VERSION
echo $MARATHON_APP_DOCKER_IMAGE
echo $MARATHON_APP_LABELS
echo $MARATHON_APP_LABEL_NAME

echo "list mesos variables"
echo $HOST
echo $MESOS_TASK_ID
echo $MESOS_SANDBOX

