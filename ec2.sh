#!/bin/bash


#
# Using Ubuntu Server 16.04 LTS (HVM), SSD Volume Type - ami-1c1d217c
AMI_ID="ami-1c1d217c"
#AWS_KEY_NAME="default-key"

#
# Create private key pair
aws ec2 create-key-pair --key-name $AWS_KEY_NAME --query 'KeyMaterial' --output text > default-key.pem
chmod 0400 default-key.pem
key_location=$(pwd) && echo Private Key: $key_location/default-key.pem

#
# Create the aws ec2 instance
#
instance=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.nano \
   --security-groups default --key-name $AWS_KEY_NAME \
   --query 'Instances[0].InstanceId' --output text) ; echo Instance ID: $instance


#
# Install nginx
#
ipaddr=$(aws ec2 describe-instances --instance-ids $instance \
   --query 'Reservations[0].Instances[0].PublicIpAddress' --output text) ; echo IP: $ipaddr
ssh -i default-key.pem -o "StrictHostKeyChecking no" ubuntu@$ipaddr sudo apt-get update && \
ssh -i default-key.pem ubuntu@$ipaddr sudo apt-get install -y nginx

#
#
#
echo Default username for Ubuntu is: ubuntu
echo test url is: http://$ipaddr

