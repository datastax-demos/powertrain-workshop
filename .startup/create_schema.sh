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
rm -rf /tmp/Powertrain*
git clone https://github.com/datastax-demos/PowertrainStreaming.git 
git clone https://github.com/datastax-demos/Powertrain2.git

cd Powertrain2

echo "Creating Cassandra schema"
cqlsh $IP -f resources/cql/create_schema.cql


echo "Creating Solr Cores"
dsetool -h $IP unload_core vehicle_tracking_app.current_location
dsetool -h $IP create_core vehicle_tracking_app.current_location reindex=true schema=resources/solr/geo.xml
dsetool -h $IP unload_core vehicle_tracking_app.vehicle_stats
dsetool -h $IP create_core vehicle_tracking_app.vehicle_stats reindex=true schema=resources/solr/geo_vehicle.xml
dsetool -h $IP unload_core vehicle_tracking_app.vehicle_events
dsetool -h $IP create_core vehicle_tracking_app.vehicle_events reindex=true schema=resources/solr/events.xml

echo "Creating DSE Graph schema"
dse gremlin-console -e resources/graph/load_schema.groovy
