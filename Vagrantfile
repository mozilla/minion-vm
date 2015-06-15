# -*- mode: ruby -*-
# vi: set ft=ruby :

# Configure as needed to share source between Vagrant and your machine
# If you update the IPs, make sure to change vagrant-hosts.sh as well
BACKEND_SRC = "/Users/april/Source/minion/minion-backend"
BACKEND_DST = "/opt/minion/minion-backend/"
BACKEND_IP = "192.168.50.49"

FRONTEND_SRC = "/Users/april/Source/minion/minion-frontend/"
FRONTEND_DST = "/opt/minion/minion-frontend/"
FRONTEND_IP = "192.168.50.50"

APT_CACHE_SRC = "/Users/april/Library/Caches/com.hashicorp.vagrant/apt-cache/" # Create this
APT_CACHE_DST = "/var/cache/apt/archives/"

# Vagrant config options
MEMORY = 1024
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # This makes subsequent builds much faster
  config.vm.synced_folder APT_CACHE_SRC, APT_CACHE_DST, owner: "root", group: "root"

  config.vm.provision "shell" do |s|
    s.path = "vagrant-hosts.sh"
  end

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", MEMORY.to_i]
  end

  # Build minion-backend
  config.vm.define "minion-backend" do |backend|
    backend.vm.hostname = "minion-backend"
    backend.vm.network "private_network", ip: BACKEND_IP
    backend.vm.synced_folder BACKEND_SRC, BACKEND_DST, create: true

    backend.vm.provision "file", source: "backend.json", destination: "/tmp/backend.json"
    backend.vm.provision "shell" do |s|
      s.path = "backend.sh"
    end
  end

  # Build minion-frontend
  config.vm.define "minion-frontend" do |frontend|
    frontend.vm.hostname = "minion-frontend"
    frontend.vm.network "private_network", ip: FRONTEND_IP
    frontend.vm.synced_folder FRONTEND_SRC, FRONTEND_DST, create: true

    frontend.vm.provision "file", source: "frontend.json", destination: "/tmp/frontend.json"
    frontend.vm.provision "shell" do |s|
      s.path = "frontend.sh"
    end
  end
end
