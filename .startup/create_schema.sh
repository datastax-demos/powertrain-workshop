#!/bin/bash

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

cd /tmp

echo "Cloning Powertrain repos"
git clone https://github.com/datastax-demos/PowertrainStreaming.git 
git clone https://github.com/datastax-demos/Powertrain2.git

echo "Creating Cassandra schema"
cqlsh $IP -f Powertrain2/resources/cql/create_schema.cql 

echo "Creating Solr Cores"
dsetool -h $IP create_core vehicle_tracking_app.current_location generateResources=true
dsetool -h $IP create_core vehicle_tracking_app.vehicle_stats generateResources=true
dsetool -h $IP create_core vehicle_tracking_app.vehicle_events generateResources=true

echo "Creating DSE Graph schema"
dse gremlin-console -e /tmp/Powertrain2/resources/graph/load_schema.groovy
