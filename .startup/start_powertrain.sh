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

#idempotence
lsof -i:9000 | grep java | awk '{print $2}' | xargs kill -9
rm -rf /tmp/Powertrain2/powertrain2-1.0-SNAPSHOT/RUNNING_PID

echo "Starting powertrain"
cd /tmp/Powertrain2/
sedi 's|this.ws = new WebSocket|this.ws = new WebSocket("ws://" + "'${IP}':9000" + "/vehicleStream");|' public/game/bkcore/hexgl/VehicleStream.js

pip install dse-driver
pip install cassandra-driver
pip install config

sbt playUpdateSecret
sbt dist
unzip target/universal/powertrain2-1.0-SNAPSHOT.zip
nohup powertrain2-1.0-SNAPSHOT/bin/powertrain2 -Dconfig.file=conf/application.conf &
