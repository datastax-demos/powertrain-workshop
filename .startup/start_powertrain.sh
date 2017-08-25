echo "Starting powertrain"
cd /tmp/powertrain-workshop/Powertrain2/
sed -i '/this.ws = new WebSocket/c\this.ws = new WebSocket("ws://" + "localhost:9000" + "/vehicleStream");' public/game/bkcore/hexgl/VehicleStream.js

sbt playUpdateSecret
sbt dist
unzip target/universal/powertrain2-1.0-SNAPSHOT.zip
powertrain2-1.0-SNAPSHOT/bin/powertrain2 -Dconfig.file=conf/application.conf