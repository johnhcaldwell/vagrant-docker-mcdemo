#!/bin/bash


yum -y install https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum -y install mcollective

erb /vagrant/templates/server.cfg.erb > /etc/mcollective/server.cfg
mkdir -p /usr/libexec/mcollective/mcollective
cp -a /vagrant/plugins/* /usr/libexec/mcollective/mcollective
        
if [[ $(grep -c $MC_BROKER_HOSTNAME /etc/hosts) -eq 0 ]]; then
    echo $MC_BROKER_IP $MC_BROKER_HOSTNAME >> /etc/hosts
fi

service mcollective restart

