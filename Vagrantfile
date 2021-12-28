# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/arch"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 4
  end
  config.vm.synced_folder "vagrant_out", "/home/vagrant/out"
  config.vm.provision "file", source: "live", destination: "/home/vagrant/live"
  config.vm.provision "shell", inline: <<-SHELL
    cd /home/vagrant/live
    pacman --noconfirm -Syu archiso
    rm -rf work
    time mkarchiso -v -o /home/vagrant/out .
  SHELL
end
