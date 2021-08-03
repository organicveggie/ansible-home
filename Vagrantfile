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
    ansible.playbook = "nas.yml"
    ansible.vault_password_file = "vault-passwd"
    ansible.become = true
    ansible.groups = {
      # "veggie_virt" => ["host1"],
      "veggie_nas" => ["host1"],
    }
    ansible.host_vars = {
      "host1" => {
        "docker_storage_driver" => "overlay2",
        "influxdb_docker_zfs_filesystems" => [],
        "influxdb_docker_data_dir" => "/var/lib/influxdb2",
        "influxdb_docker_conf_dir" => "/etc/influxdb2",
        "telegraf_plugin_smartctl" => false,
      }
    }
    ansible.tags = "telegraf"
  end
end
