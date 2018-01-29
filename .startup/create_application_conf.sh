HOST_IP="$(grep 'node0_ext' /etc/hosts | cut -d$'\t' -f 1)"
cd /tmp/Powertrain2/conf

cp /tmp/Powertrain2/conf/application._template.conf /tmp/Powertrain2/conf/application.conf
sed -i '/dse_graph_host/c\dse_graph_host="'${HOST_IP}'"' application.conf
sed -i '/graph_name/c\graph_name="powertrain_graph"' application.conf
sed -i '/github_client_id/c\github_client_id="a81ec76eb967c5dc2d56"' application.conf
sed -i '/github_client_secret/c\github_client_secret="a3056a4e0e66b36aa4436346ba2694acf30c891d"' application.conf

sed -i '/        graph_name/c\        graph_name = "powertrain_graph"' networkByUser.py
sed -i '/        local_datacenter/c\        local_datacenter = "DC1"' networkByUser.py

sed -i '/tokens/c\tokens:["717e5a3784e7037a6a1c3014bae19a1ede97aa52"]' application.cfg


# cd /tmp/Powertrain2/public/game

# sed -i '/authorize?client_id/c\<a style="color:#000000" href="https://github.com/login/oauth/authorize?client_id=a81ec76eb967c5dc2d56">' index.html