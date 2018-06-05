#!/usr/bin/env bash

which tmux wget unzip &>/dev/null || {
  apt-get update
  apt-get install -y wget unzip tmux
}

which nomad &>/dev/null || {
  pushd /usr/local/bin
  wget https://releases.hashicorp.com/nomad/0.8.3/nomad_0.8.3_linux_amd64.zip
  unzip nomad_0.8.3_linux_amd64.zip
  chmod +x nomad
  popd
}

IFACE=`route -n | awk '$1 == "192.168.2.0" {print $8}'`
CIDR=`ip addr show ${IFACE} | awk '$2 ~ "192.168.2" {print $2}'`
IP=${CIDR%%/24}

grep NOMAD_ADDR ~/.bash_profile || {
  echo export NOMAD_ADDR=http://${IP}:4646 | tee -a ~/.bash_profile
}

# check for consul hostname => server
if [[ "${HOSTNAME}" =~ "nomad-server" ]]; then

  NOMAD_ADDR=http://${IP}:4646 /usr/local/bin/nomad agent-info 2>/dev/null || {
    /usr/local/bin/nomad agent -server -bind=${IP} -data-dir=/usr/local/nomad -join=192.168.2.21 -join=192.168.2.22 -join=192.168.2.23 -bootstrap-expect=3 >/vagrant/${HOSTNAME}.log &
    sleep 1
  }

else

  NOMAD_ADDR=http://${IP}:4646 /usr/local/bin/nomad agent-info 2>/dev/null || {
    /usr/local/bin/nomad agent -client -bind=${IP} -data-dir=/usr/local/nomad -join=192.168.2.21 -join=192.168.2.22 -join=192.168.2.23 >/vagrant/${HOSTNAME}.log &
    sleep 1
  }

fi
