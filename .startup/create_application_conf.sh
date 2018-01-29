HOST_IP="$(grep 'node0_ext' /etc/hosts | cut -d$'\t' -f 1)"
cd /tmp/Powertrain2/conf

cp /tmp/Powertrain2/conf/application._template.conf /tmp/Powertrain2/conf/application.conf
sed -i '/dse_graph_host/c\dse_graph_host="'${HOST_IP}'"' application.conf
sed -i '/graph_name/c\graph_name="powertrain_graph"' application.conf
sed -i '/github_client_id/c\github_client_id="a81ec76eb967c5dc2d56"' application.conf
sed -i '/github_client_secret/c\github_client_secret="a3056a4e0e66b36aa4436346ba2694acf30c891d"' application.conf

sed -i '/tokens/c\tokens:["c57b7dfa59d36e8b7edc0134b79f6ee293de6f86"]' application.cfg