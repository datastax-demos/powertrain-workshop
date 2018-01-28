echo "Starting powertrain"
HOST_IP="$(grep 'node0' /etc/hosts | cut -d$'\t' -f 1 | head -n1)"
cd /tmp/Powertrain2/
sed -i '/this.ws = new WebSocket/c\this.ws = new WebSocket("ws://" + "'${HOST_IP}':9000" + "/vehicleStream");' public/game/bkcore/hexgl/VehicleStream.js

sbt playUpdateSecret
sbt dist
unzip target/universal/powertrain2-1.0-SNAPSHOT.zip
powertrain2-1.0-SNAPSHOT/bin/powertrain2 -Dconfig.file=conf/application.conf