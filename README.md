vagrant-docker-mcdemo
=====================

This serves as a (semi) functional demonstrator for a RabbitMQ-based 
MCollective installation on Oracle Linux 6.  No plugins are included out of
the box; you will need to add them under mcollective/plugins before 
provisioning the nodes.  Nearly all of the configuration is contained within
the `Vagrantfile` itself.  Unless you have a specific need to configure the
hostnames, ports, or authentication details, no configuration is necessary
to have a functional environment.

Requirements
------------
    * Vagrant 2.0
    * Docker CE 17



Setup
-----
    $ git clone https://github.com/johnhcaldwell/vagrant-docker-mcdemo.git
    $ cd vagrant-docker-mcdemo


    * Place any mcollective plugins you require under `mcollective/plugins`
    * Adjust the `NODE_COUNT` parameter within the `Vagrantfile to suit
      your needs.  The default configuration is to create 10 containers in total,
      one broker and 9 nodes.

Using it
--------
    $ cd vagrant-docker-mcdemo
    $ vagrant up
    $ vagrant ssh broker01 
    $ sudo su -
    $ mco ping
