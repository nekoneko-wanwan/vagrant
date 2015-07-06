# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "centos64"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 35729, host: 35729
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.hostname = "localhost"

  # config.vm.network "public_network"

  config.vm.provision :shell, path: "script/base.sh"
  # config.vm.synced_folder "./documentRoot", "/var/www/html/public_html"
  config.vm.synced_folder "./documentRoot", "/var/www/html/public_html", type: "rsync", rsync__chown: false

  config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.memory = "1024"
     # vb.gui = true
  end

end
