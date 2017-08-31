HOST_IP="$(grep 'node0_ext' /etc/hosts | cut -d$'\t' -f 1| awk '{ print $1}')"

cd /tmp/Powertrain2/conf

cp /tmp/Powertrain2/conf/application._template.conf /tmp/Powertrain2/conf/application.conf
awk '{gsub("127.0.0.1", '"$HOST_IP"', $0); print}' /tmp/Powertrain2/conf/application._template.conf > application.conf
sed -i '/graph_name/c\graph_name="powertrain_graph"' application.conf