#!/bin/bash
# This bootstraps Puppet on CentOS 6.x
# It has been tested on CentOS 6.3 64bit

set -e


if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

echo "Installing Hiera"sudo 
yum install -y hiera > /dev/null

declare -a moduleList=('puppetlabs-firewall' 'rcoleman-puppet_module' 'puppetlabs-mysql' 'puppet-hiera');
for module in "${moduleList[@]}"
do
    (puppet module --modulepath "/etc/puppet/modules" list | grep -o ${module}) || puppet module install ${module}
done