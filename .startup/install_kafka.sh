HOST_IP="$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"

#Install kafka
cd /tmp

wget http://apache.claz.org/kafka/0.10.0.0/kafka_2.10-0.10.0.0.tgz
tar -xvf kafka_2.10-0.10.0.0.tgz
cd kafka_2.10-0.10.0.0
nohup bin/zookeeper-server-start.sh config/zookeeper.properties 2>&1 1> zookeeper.log &
nohup bin/kafka-server-start.sh config/server.properties 2>&1 1> kafka.log &
export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname='$HOST_IP' -Dcom.sun.management.jmxremote.port=5052"
sleep 120
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 5 --topic vehicle_events
