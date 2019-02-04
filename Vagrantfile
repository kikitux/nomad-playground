# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "alvaro/xenial64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  #server
  config.vm.define "server" do |s|
    s.vm.hostname = "server"
    s.vm.network "private_network", ip: "192.168.56.20"
    s.vm.network "forwarded_port", guest: 4646, host: 4646 #nomad
    s.vm.network "forwarded_port", guest: 8200, host: 8200 #vault
    s.vm.network "forwarded_port", guest: 8500, host: 8500 #consul
    s.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh"
    s.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.sh"
    s.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.sh"
  end

  #client
  (1..2).each do |i|  
    config.vm.define "client#{i}" do |c|
      c.vm.hostname = "client#{i}"
      c.vm.network "private_network", ip: "192.168.56.#{30+i}"
      c.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh"
      c.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-client/nomad.sh"
    end
  end

end
