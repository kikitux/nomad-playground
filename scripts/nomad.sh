#!/usr/bin/env bash

IFACE=`route -n | awk '$1 == "0.0.0.0" {print $8;exit}'`
CIDR=`ip addr show ${IFACE}  | awk '$0 ~ "inet " {print $2}'`
IP=${CIDR%%/24}

if [ -d /vagrant ]; then
  LOG="/vagrant/logs/nomad_${HOSTNAME}.log"
else
  LOG="nomad_${HOSTNAME}.log"
fi

which wget unzip &>/dev/null || {
  apt-get update
  apt-get install -y wget unzip 
}

which nomad &>/dev/null || {
  pushd /usr/local/bin
  wget https://releases.hashicorp.com/nomad/0.8.4/nomad_0.8.4_linux_amd64.zip
  unzip nomad_0.8.4_linux_amd64.zip
  chmod +x nomad
  popd
}

which http-echo &>/dev/null || {
  pushd /usr/local/bin
  wget https://github.com/hashicorp/http-echo/releases/download/v0.2.3/http-echo_0.2.3_linux_amd64.zip
  unzip http-echo_0.2.3_linux_amd64.zip
  chmod +x http-echo
  popd
}

grep NOMAD_ADDR ~/.bash_profile &>/dev/null || {
  echo export NOMAD_ADDR=http://${IP}:4646 | tee -a ~/.bash_profile
}


# check for nomad hostname => server
if [[ "${HOSTNAME}" =~ "nomad-server" ]]; then

  NOMAD_ADDR=http://${IP}:4646 /usr/local/bin/nomad agent-info 2>/dev/null || {
    /usr/local/bin/nomad agent -server -bind=${IP} -data-dir=/usr/local/nomad -bootstrap-expect=3 -join=192.168.2.21 -join=192.168.2.22 -join=192.168.2.23 -config=/etc/nomad.d > ${LOG} &
    sleep 1
  }

else

  NOMAD_ADDR=http://${IP}:4646 /usr/local/bin/nomad agent-info 2>/dev/null || {
    mkdir -p /etc/nomad.d
    cp -ap /vagrant/conf/nomad.d/client.hcl /etc/nomad.d/
    /usr/local/bin/nomad agent -client -bind=${IP} -data-dir=/usr/local/nomad -join=192.168.2.21 -join=192.168.2.22 -join=192.168.2.23 -config=/etc/nomad.d > ${LOG} &
    sleep 1
  }

fi
