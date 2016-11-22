# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

Vagrant.configure("2") do |config|
  properties = YAML.load_file("properties.yml")

  config.vm.box = "CumulusCommunity/cumulus-vx"

  # Number of nodes to provision
  iter = 1
  
  # Spine configuration
  1.upto(properties[:numSpines]) do |num|
    nodeName = ( "s" + num.to_s + ".demo.lan" ).to_sym
    devName = ("s" + num.to_s)
    peerAsn = Hash.new
    config.vm.define nodeName do |node|
      node.vm.hostname = nodeName
      1.upto(properties[:numLeaves]) do |leaf|
        leafname = ("l" + leaf.to_s)
        ifname = ("swp" + leaf.to_s)
        node.vm.network "private_network",
                        virtualbox__intnet: devName + "-" + leafname
        peerAsn[ifname] = properties[:leafAsnBase] + leaf
      end
      node.vm.network "private_network",
	virtualbox__intnet: "s" + num.to_s + ".demo.lan"

      config.vm.provision "shell", path: "setup.sh", args: [properties[:masterIp], properties[:masterName], 'cmlx_spine']
      iter += 1
    end
  end

  # Leaf configuration
  1.upto(properties[:numLeaves]) do |num|
    nodeName = ( "l" + num.to_s + ".demo.lan" ).to_sym
    devName = ("l" + num.to_s)
    peerAsn = Hash.new
    config.vm.define nodeName do |node|
      node.vm.hostname = nodeName
      1.upto(properties[:numSpines]) do |spine|
        spinename = ("s" + spine.to_s)
        ifname = ("swp" + spine.to_s)
        node.vm.network "private_network",
                        virtualbox__intnet: spinename + "-" + devName
        peerAsn[ifname] = properties[:spineAsn]
      end
      node.vm.network "private_network",
	virtualbox__intnet: "l" + num.to_s + ".demo.lan"

      config.vm.provision "shell", path: "setup.sh", args: [properties[:masterIp], properties[:masterName], 'cmlx_leaf']
      iter += 1
    end
  end

end
