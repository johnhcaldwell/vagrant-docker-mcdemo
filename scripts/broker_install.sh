#!/bin/bash

yum -y install http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum -y install https://github.com/rabbitmq/erlang-rpm/releases/download/v1.3.1/erlang-18.3.4.4-1.el6.x86_64.rpm
yum -y install https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_6_7/rabbitmq-server-3.6.7-1.el6.noarch.rpm
yum -y install mcollective-client

rabbitmq-plugins --offline enable rabbitmq_stomp rabbitmq_management
echo "[ {rabbitmq_stomp, [{tcp_listeners, [$MC_BROKER_PORT]}]} ]." > /etc/rabbitmq/rabbitmq.config
service rabbitmq-server start
curl -L https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/rabbitmq_v3_6_7/bin/rabbitmqadmin -o /usr/sbin/rabbitmqadmin && chmod 750 /usr/sbin/rabbitmqadmin
rabbitmqadmin declare vhost name=/mcollective
rabbitmqadmin declare user name=$MC_USERNAME password=$MC_PASSWORD tags=
rabbitmqadmin declare user name=admin password=changeme tags=administrator
rabbitmqadmin declare permission vhost=/mcollective user=mcollective configure='.*' write='.*' read='.*'
rabbitmqadmin declare exchange --user=admin --password=changeme --vhost=/mcollective name=mcollective_broadcast type=topic
rabbitmqadmin declare exchange --user=admin --password=changeme --vhost=/mcollective name=mcollective_directed type=direct

erb /vagrant/mcollective/client.cfg.erb > /etc/mcollective/client.cfg

