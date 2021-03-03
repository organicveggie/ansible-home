# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.define "host1"
  config.vm.box = "generic/ubuntu2004"
  config.vm.network "private_network", ip: "172.30.1.5"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 1
  end
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "nas.yml"
    ansible.become = true
    ansible.groups = {
      "nas" => ["host1"],
    }
    ansible.host_vars = {
      "host1" => {"docker_storage_driver" => "overlay2"}
    }
  end
end
