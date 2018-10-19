#!/bin/bash

# Copyright (c) 2018 Jerry
# This script is aim to install stable version of docker-ce automatically. 
# All details can access from: https://docs.docker.com/install/linux/docker-ce/centos/

# Uninstall old versions
sudo yum remove docker \
	     docker-client \
	     docker-client-latest \
	     docker-common \
	     docker-latest \
	     docker-latest-logrotate \
	     docker-logrotate \
	     docker-selinux \
	     docker-engine-selinux \
	     docker-engine

# SET UP THE REPOSITORY
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# Use stable version using aliyun mirrors
sudo yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    #https://download.docker.com/linux/centos/docker-ce.repo

# *** If you want to include edge or test version, try follow
# sudo yum-config-manager --enable docker-ce-edge
# sudo yum-config-manager --enable docker-ce-edge

# INSTALL DOCKER
sudo yum install -y docker-ce-17.12.1.ce-1.el7.centos

# *** If you want to install specific version of docker-ce:
# *** first, find out what version they have:
# yum list docker-ce --showduplicates | sort -r
# *** then, install with specific version:
# sudo yum install docker-ce-<VERSION STRING>

# TO START DOCKER:
sudo systemctl start docker

# *** Change to aliyun mirrors
#sudo mkdir -p /etc/docker
#sudo tee /etc/docker/daemon.json <<-'EOF'
#{
#  "registry-mirrors": ["https://ctte8c2f.mirror.aliyuncs.com"]
#}
#EOF
#sudo systemctl daemon-reload
#sudo systemctl restart docker

# verify that docker is installed correctly
sudo docker pull hello-world
sudo docker run --rm hello-world
sudo docker rmi hello-world

# *** TO UNINSTALL DOCKER:
# sudo yum remove docker-ce
# sudo rm -rf /var/lib/docker
