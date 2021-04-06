# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.define "host1"
  config.vm.box = "generic/ubuntu2004"
  config.vm.network "public_network", ip: "192.168.25.61"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 1
  end
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "virt.yml"
    ansible.vault_password_file = "vault-passwd"
    ansible.become = true
    ansible.groups = {
      "veggie_virt" => ["host1"],
      # "veggie_nas" => ["host1"],
    }
    ansible.host_vars = {
      "host1" => {
        "docker_storage_driver" => "overlay2",
        "postgresql_docker_memory" => "1GB",
        "postgresql_docker_cpu" => "1",
      }
    }
    # ansible.tags = "docker,pip,traefik,postgres"
  end
end
