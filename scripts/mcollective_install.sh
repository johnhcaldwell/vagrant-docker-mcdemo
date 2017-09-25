#!/bin/bash


yum -y install https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum -y install mcollective

erb /vagrant/mcollective/server.cfg.erb > /etc/mcollective/server.cfg
        
if [[ $(grep -c $MC_BROKER_HOSTNAME /etc/hosts) -eq 0 ]]; then
    echo $MC_BROKER_IP $MC_BROKER_HOSTNAME >> /etc/hosts
fi

service mcollective restart

