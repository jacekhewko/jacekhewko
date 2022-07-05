#!/bin/bash
amazon-linux-extras disable docker
amazon-linux-extras install -y ecs
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
systemctl enable --now --no-block ecs.service </dev/null
yum -y upgrade
yum -y update
yum install amazon-efs-utils
systemctl enable --now amazon-ecs-volume-plugin
yum -y install https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
iptables -A INPUT -s 169.254.172.0/22 -j ACCEPT
iptables -A INPUT -i docker+ -p tcp -m multiport --dports 18080,19080,80,17701,8080,8092,9092,8585,7701,8584,25 -j ACCEPT
iptables-save > /etc/sysconfig/iptables
