#!/usr/bin/env bash

IFACE=`route -n | awk '$1 == "0.0.0.0" {print $8;exit}'`
CIDR=`ip addr show ${IFACE}  | awk '$0 ~ "inet " {print $2}'`
IP=${CIDR%%/24}

if [ -d /vagrant ]; then
  LOG="/vagrant/logs/consul_${HOSTNAME}.log"
else
  LOG="consul_${HOSTNAME}.log"
fi  

which wget unzip &>/dev/null || {
  apt-get update
  apt-get install -y wget unzip 
}

which /usr/local/bin/consul &>/dev/null || {
  pushd /usr/local/bin
  [ -f consul_1.2.1_linux_amd64.zip ] || {
    wget https://releases.hashicorp.com/consul/1.2.1/consul_1.2.1_linux_amd64.zip
  }
  unzip consul_1.2.1_linux_amd64.zip
  chmod +x consul
  popd
}

# check for consul hostname => server
if [[ "${HOSTNAME}" =~ "consul" ]]; then
  echo server
  /usr/local/bin/consul members 2>/dev/null || {
    /usr/local/bin/consul agent -server -ui -client=0.0.0.0 -bind=${IP} -data-dir=/usr/local/consul -join=192.168.2.11 -join=192.168.2.12 -join=192.168.2.13 -bootstrap-expect=3 >${LOG} &
    sleep 1
  }
else
  echo agent
  /usr/local/bin/consul members 2>/dev/null || {
    /usr/local/bin/consul agent -bind=${IP} -data-dir=/usr/local/consul -join=192.168.2.11 -join=192.168.2.12 -join=192.168.2.13 >${LOG} &
    sleep 1
  }
fi
    
echo consul started
