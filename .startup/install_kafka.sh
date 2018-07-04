#!/bin/bash

IP=$(ifconfig | awk '/inet/ { print $2 }' | egrep -v '^fe|^127|^192|^172|::' | head -1)
IP=${IP#addr:}

if [[ $HOSTNAME == "node"* ]] ; then
    #rightscale
    IP=$(grep $(hostname)_ext /etc/hosts | awk '{print $1}')
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    IP=localhost
fi

#Install kafka
cd /tmp

wget http://apache.claz.org/kafka/1.0.0/kafka_2.11-1.0.0.tgz
tar -xvf kafka_2.11-1.0.0.tgz
cd kafka_2.11-1.0.0
nohup bin/zookeeper-server-start.sh config/zookeeper.properties 2>&1 1> zookeeper.log &
nohup bin/kafka-server-start.sh config/server.properties 2>&1 1> kafka.log &
export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname='$IP' -Dcom.sun.management.jmxremote.port=5052"
sleep 120
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic vehicle_events
