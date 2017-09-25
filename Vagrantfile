Vagrant.require_version ">= 2.0"

# Define the number of nodes to start.  This includes the broker
NODE_COUNT = 10

# The name of the docker private network for all nodes to use. This Must be 
# created in docker first via:
#     docker network create -d bridge --subnet <subnet> <INTNET_NAME>
#
INTNET_NAME = 'vagrant-mcdemo-priv'

# MCollective configuration
#
mc_config = {
    :MC_BROKER_HOSTNAME => 'broker01',
    :MC_BROKER_PORT     => 5153,
    :MC_USERNAME        => 'mcollective',
    :MC_PASSWORD        => 'changeme'
}


intnet_subnet = %x(docker network inspect -f "{{(index .IPAM.Config 0).Subnet}}" #{INTNET_NAME}).chomp
if !intnet_subnet.include?('/')
    $stderr.puts "FATAL: Docker network missing. Please create it first"
    exit 1
end

network, mask = intnet_subnet.split('/')
PREFIX     = network.sub(/\d+$/,'')



Vagrant.configure(2) do |config|

  ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

  config.vm.provider "docker" do |d|
    d.image = "johnhcaldwell/vagrant-oraclelinux:6"
    d.has_ssh = true
  end
  
  NODE_COUNT.times do |i|
    node_ip = PREFIX + (i+10).to_s
    if i == 0
        node_hostname = mc_config[:MC_BROKER_HOSTNAME]
        mc_config[:MC_BROKER_IP] = node_ip
    else
        node_hostname = "node%02i" % i
    end
    config.vm.define node_hostname do |node|

      node.vm.provider "docker" do |v|
        v.create_args = ['--network='+INTNET_NAME,'--ip='+node_ip]
      end

      node.vm.hostname = node_hostname

      if node_hostname == mc_config[:MC_BROKER_HOSTNAME]
        node.vm.provision :shell, inline: '/bin/bash /vagrant/scripts/broker_install.sh', env: mc_config
      else 
        node.vm.provision :shell, inline: '/bin/bash /vagrant/scripts/mcollective_install.sh', env: mc_config
      end

    end
  end

end
