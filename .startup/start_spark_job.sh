#!/bin/bash

sedi () {
    sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@"
}

set -x
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

echo "Submitting Spark Streaming Job"
sedi 's/spark.dse_host.*/spark.dse_host    '${IP}'/' /tmp/PowertrainStreaming/conf/application.conf

cd /tmp/PowertrainStreaming

if [[ $HOSTNAME == "node"* ]] ; then
su ds_user <<'EOF'
sudo chown -R ds_user /tmp/PowertrainStreaming
cd /tmp/PowertrainStreaming
sbt package
EOF
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
sbt package
fi

nohup dse spark-submit --packages org.apache.spark:spark-streaming-kafka-0-10_2.11:2.0.2 --conf=spark.executor.memory=3g --class powertrain.StreamVehicleData --properties-file=/tmp/PowertrainStreaming/conf/application.conf /tmp/PowertrainStreaming/target/scala-2.11/streaming-vehicle-app_2.11-1.0-SNAPSHOT.jar &
