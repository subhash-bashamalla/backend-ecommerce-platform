#!/bin/bash

yum update -y
yum install docker -y
systemctl start docker
systemctl enable docker

usermod -aG docker ec2-user
docker pull 
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins 
