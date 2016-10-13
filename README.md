# Apache Kafka Docker Image Running on Marathon

## Motivation

Currently there is a solution out there that are available for running Apache Kafka on Mesos: [mesos/kafka](https://github.com/mesos/kafka) Scheduler and it is seemingly a pretty good managed solution, but it seems to be relatively out of date and no maintainers are active.

There are a couple of Docker Images on Docker Hub, but they require some tweaking to work for Marathon (especially around ports allocation and use of persistent storage).

## Inspiration

I found a couple of projects that help me kick-start the Docker image building process:

* https://github.com/wurstmeister/kafka-docker
* https://github.com/tobilg/docker-kafka-marathon
* https://github.com/elodina/kafka-manager

Hooli Beijing, October 2016