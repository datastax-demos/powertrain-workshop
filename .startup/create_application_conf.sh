HOST_IP="$(/sbin/ip route|awk '/eth0/ { print $9 }')"

cp Powertrain2/conf/application._template.conf application.conf
sed -i '/dse_graph_host/c\dse_graph_host="'$HOST_IP'"' application.conf
sed -i '/graph_name/c\graph_name="powertrain_graph"' application.conf
