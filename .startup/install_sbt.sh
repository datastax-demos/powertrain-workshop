#!/bin/bash

set -x

if [ ! -x sbt ] && [ ! -x "$(command -v sbt)" ] ; then
    if [[ $HOSTNAME == "node"* ]] ; then
        #rightscale
        echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
        sleep 60
        sudo apt-get update
        sudo apt-get -y --force-yes install sbt
    fi
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        brew install sbt@1
    fi
fi
