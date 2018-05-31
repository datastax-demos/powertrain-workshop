#!/bin/bash

set -x

IP=$(ifconfig | awk '/inet/ { print $2 }' | egrep -v '^fe|^127|^192|^172|::' | head -1)
IP=${IP#addr:}

DL_SUFFIX=Linux-64bit
INNER_SUFFIX=linux_amd64
HUGO_VERSION=0.27

if [[ $HOSTNAME == "node"* ]] ; then
    #rightscale
    IP=$(grep $(hostname)_ext /etc/hosts | awk '{print $1}')
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    IP=localhost
fi

cd /tmp/Powertrain2/conf
sedi () {
    sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@"
}

cp /tmp/Powertrain2/conf/application._template.conf /tmp/Powertrain2/conf/application.conf
sedi 's/dse_graph_host.*/dse_graph_host="'${IP}'"/' application.conf
sedi 's/graph_name.*/graph_name="powertrain_graph"/' application.conf
sedi 's/github_client_id.*/github_client_id="a81ec76eb967c5dc2d56"/' application.conf
sedi 's/github_client_secret.*/github_client_secret="a3056a4e0e66b36aa4436346ba2694acf30c891d"/' application.conf

sedi 's/        graph_name.*/        graph_name = "powertrain_graph"/' networkByUser.py
sedi 's/        local_datacenter.*/        local_datacenter = "DC1"/' networkByUser.py
sedi 's:    f = file("application.cfg").*:    f = file("/tmp/Powertrain2/powertrain2-1.0-SNAPSHOT/conf/application.cfg"):' networkByUser.py

sedi 's/tokens.*/tokens:["717e5a3784e7037a6a1c3014bae19a1ede97aa52"]/' application.cfg

# cd /tmp/Powertrain2/public/game

# sed -i '/authorize?client_id/c\<a style="color:#000000" href="https://github.com/login/oauth/authorize?client_id=a81ec76eb967c5dc2d56">' index.html
