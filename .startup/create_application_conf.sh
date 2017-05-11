HOST_IP="$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"

cp Powertrain2/conf/application._template.conf application.conf
awk '{gsub("127.0.0.1", '"$HOST_IP"', $0); print}' Powertrain2/conf/application._template.conf > application.conf
sed -i '/graph_name/c\graph_name="powertrain_graph"' application.conf