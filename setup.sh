#!/bin/bash

echo "${1} ${2} puppet" >> /etc/hosts
mkdir -p /opt/puppetlabs/facter/facts.d
echo "role: ${3}" > /opt/puppetlabs/facter/facts.d/role.yaml

wget http://apt.puppetlabs.com/puppetlabs-release-pc1-cumulus.deb
sudo dpkg -i puppetlabs-release-pc1-cumulus.deb
sudo apt-get update
sudo apt-get install puppet-agent
sudo /opt/puppetlabs/bin/puppet agent -t
sudo /opt/puppetlabs/bin/puppet agent -t

