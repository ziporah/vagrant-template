# -*- mode: ruby -*-
# # vi: set ft=ruby :
 
# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"
 
# Require YAML module
require 'yaml'
 
# Read YAML file with box details
servers = YAML.load_file('servers.yaml')
 
# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-proxyconf")
#    config.proxy.http     = "http://192.168.0.2:3128/"
#    config.yum_proxy.http    = "http://apt-cacher-ng.lanzone.home:3142/"
#    config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
    config.apt_proxy.http = "http://apt-cacher-ng.lanzone.home:3142"
    config.apt_proxy.https    = "DIRECT"
  end
 
  # Iterate through entries in YAML file
servers.each do |servers|
    
  config.vm.define servers["name"] do |srv|
    
    srv.vm.hostname = servers["name"]
    
    srv.vm.box = servers["box"]
    
    srv.vm.network "private_network"
	# ,ip: servers["virt_ip"]
    srv.vm.network :public_network,
#            :ip => servers["pub_ip"],
	    :dev => "br0",
	    :network_name => "default",
	    :mode => "bridge",
	    :type => "bridge"
    servers["forward_ports"].each do |port| 
      srv.vm.network :forwarded_port, guest: port["guest"], host: port["host"], host_ip: "0.0.0.0"

    end

    srv.vm.provider :libvirt do |v|
        v.cpus = servers["cpu"]
        v.memory = servers["ram"]
	v.graphics_passwd = "vagrant"
	v.graphics_ip = "0.0.0.0"
	v.storage_pool_name = "vagrant"
    end

    srv.vm.provider :virtualbox do |v|
        v.cpus = servers["cpu"]
        v.memory = servers["ram"]
    end
   
    srv.vm.synced_folder "./", "/home/vagrant/#{servers['name']}"
    
    servers["shell_commands"].each do |sh|
      srv.vm.provision "shell", inline: sh["shell"]
    end
    
    srv.vm.provision :puppet do |puppet|
        puppet.temp_dir = "/tmp"
        puppet.options = ['--modulepath=/tmp/modules', '--verbose']
        puppet.hiera_config_path = "hiera.yaml"  
      
        end
      end
    end
  end
