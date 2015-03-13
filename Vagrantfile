# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Increase the memory
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "chef/centos-7.0"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://vagrantcloud.com/chef/boxes/centos-7.0/versions/1.0.0/providers/virtualbox.box"

  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network :forwarded_port, guest: 80, host: 8081
  # config.vm.network :forwarded_port, guest: 22, host: 2222


  config.vm.provision "shell", path: "bootstrap.sh"

end