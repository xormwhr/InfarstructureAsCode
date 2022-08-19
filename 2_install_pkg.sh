#!/usr/bin/env bash

# install packages 
yum install epel-release -y
yum install vim-enhanced -y
yum install git -y

# install docker 
yum install docker-ce docker-ce-cli containerd.io -y
systemctl enable --now docker

# install kubernetes cluster 
yum install kubectl kubelet kubeadm -y
systemctl enable --now kubelet
