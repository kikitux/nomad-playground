Vagrant.configure("2") do |config|
  config.vm.box = "cbednarski/ubuntu-1604"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  #consul
  (1..3).each do |i|
    config.vm.define vm_name = "consul#{i}" do |consul|
        consul.vm.hostname = vm_name
        consul.vm.network "private_network", ip: "192.168.2.1#{i}"
        consul.vm.network "forwarded_port", guest: 8500, host: 8500 + i
      consul.vm.provision "shell", path: "scripts/consul.sh"
    end
  end

  #nomad-server
  (1..3).each do |i|
    config.vm.define vm_name = "nomad-server#{i}" do |nomad|
      nomad.vm.hostname = vm_name
      nomad.vm.network "private_network", ip: "192.168.2.2#{i}"
      nomad.vm.network "forwarded_port", guest: 8200, host: 8200 + i
      nomad.vm.provision "shell", path: "scripts/consul.sh"
      nomad.vm.provision "shell", path: "scripts/nomad.sh"
    end
  end

  #nomad-agent
  (1..3).each do |i|
    config.vm.define vm_name = "nomad-agent#{i}" do |nomad|
      nomad.vm.hostname = vm_name
      nomad.vm.network "private_network", ip: "192.168.2.3#{i}"
      nomad.vm.provision "shell", path: "scripts/docker.sh"
      nomad.vm.provision "shell", path: "scripts/consul.sh"
      nomad.vm.provision "shell", path: "scripts/nomad.sh"
    end
  end

end
