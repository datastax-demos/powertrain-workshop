HOST_IP="$(grep 'node0' /etc/hosts | cut -d$'\t' -f 1 | head -n1)"
echo "Submitting Spark Streaming Job"
sed -i '/spark.dse_host/c\spark.dse_host'$'\t'${HOST_IP} /tmp/PowertrainStreaming/conf/application.conf
cd /tmp/PowertrainStreaming
sbt package
nohup dse spark-submit --packages org.apache.spark:spark-streaming-kafka_2.10:1.6.0 --conf=spark.executor.memory=8g --class powertrain.StreamVehicleData  --properties-file=/tmp/PowertrainStreaming/conf/application.conf /tmp/PowertrainStreaming/target/scala-2.10/streaming-vehicle-app_2.10-1.0-SNAPSHOT.jar 2>&1 1> streaming.log &