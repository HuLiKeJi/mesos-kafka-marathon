#!/usr/bin/python

import os, sys
from kazoo.client import KazooClient

zk = KazooClient(hosts=os.getenv('KAFKA_ZOOKEEPER_CONNECT'))
zk.start()

zk_broker_ids = zk.get_children('/brokers/ids')
set_broker_ids = set(map(int, zk_broker_ids))

possible_broker_ids = set(range(int(sys.argv[1])))

broker_id = sorted(possible_broker_ids - set_broker_ids)[0]

print broker_id