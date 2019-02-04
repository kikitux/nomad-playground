# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "alvaro/xenial64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  #server
  config.vm.define vm_name = "server" do |s|
    s.vm.hostname = vm_name
    s.vm.network "private_network", ip: "192.168.2.20"
    s.vm.network "forwarded_port", guest: 8200, host: 8200 + i
    #s.vm.provision "shell", path: "scripts/consul.sh", run: "always" 
    #s.vm.provision "shell", path: "scripts/nomad.sh", run: "always"
  end

  #agent
  config.vm.define vm_name = "client" do |c|
    c.vm.hostname = vm_name
    c.vm.network "private_network", ip: "192.168.2.30"
    c.vm.provision "shell", path: "scripts/docker.sh"
    #c.vm.provision "shell", path: "scripts/consul.sh", run: "always"
    #c.vm.provision "shell", path: "scripts/nomad.sh", run: "always"
  end

end
