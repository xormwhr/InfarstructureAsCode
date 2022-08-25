#!/usr/bin/env bash

# yum list docker-ce --showduplicates | sort -r
# yum list docker-ce-cli --showduplicates | sort -r
# yum list containerd.io --showduplicates | sort -r

# yum list kubectl --showduplicates | sort -r
# yum list kubelet --showduplicates | sort -r
# yum list kubeadm --showduplicates | sort -r

# install packages 
yum install epel-release -y
yum install vim-enhanced -y
yum install git -y

# install docker 
yum install docker-ce-20.10.17-3.el7 \ 
            docker-ce-cli-20.10.17-3.el7 \
            containerd.io-1.6.7-3.1.el7 -y
systemctl enable --now docker

# install kubernetes cluster
yum install kubectl-1.24.4-0 \
            kubelet-1.24.4-0 \
            kubeadm-1.24.4-0 -y
systemctl enable --now kubelet
