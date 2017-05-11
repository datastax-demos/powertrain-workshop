#!/bin/sh
HOST_IP="$(/sbin/ip route|awk '/eth0/ { print $9 }')"

#Install kafka
wget https://www.apache.org/dyn/closer.cgi?path=/kafka/0.10.0.0/kafka_2.10-0.10.0.0.tgz
tar -xvf kafka_2.10-0.10.0.0.tgz
cd kafka_2.10-0.10.0.0
nohup bin/zookeeper-server-start.sh config/zookeeper.properties 2>&1 1> zookeeper.log &
nohup bin/kafka-server-start.sh config/server.properties 2>&1 1> kafka.log &
export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname='$HOST_IP' -Dcom.sun.management.jmxremote.port=5052"
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 5 --topic vehicle_events

#Install powertrain
cd /Powertrain2/
cp conf/application._template.conf conf/application.conf
sed -i '/dse_graph_host/c\dse_graph_host="'$HOST_IP'"' conf/application.conf
sed -i '/graph_name/c\graph_name="powertrain_graph"' conf/application.conf
sed -i '/this.ws = new WebSocket/c\this.ws = new WebSocket("ws://" + "localhost:9000" + "/vehicleStream");' public/game/bkcore/hexgl/VehicleStream.js

sbt playUpdateSecret
sbt dist
unzip target/universal/powertrain2-1.0-SNAPSHOT.zip
powertrain2-1.0-SNAPSHOT/bin/powertrain2 -Dconfig.file=conf/application.conf
