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


# check for consul hostname => server
if [[ "${HOSTNAME}" =~ "nomad-server" ]]; then

  /usr/local/bin/consul members 2>/dev/null || {
    /usr/local/bin/nomad agent -server  -bind=${IP} -data-dir=/usr/local/nomad -join=192.168.2.21 -join=192.168.2.22 -join=192.168.2.23 -bootstrap-expect=3 >/vagrant/${HOSTNAME}.log &
    sleep 1
  }

else

  /usr/local/bin/consul members 2>/dev/null || {
    /usr/local/bin/nomad agent  -bind=${IP} -data-dir=/usr/local/nomad -join=192.168.2.21 -join=192.168.2.22 -join=192.168.2.23 -bootstrap-expect=3 >/vagrant/${HOSTNAME}.log &
    sleep 1
  }

fi
