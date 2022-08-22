#!/usr/bin/env bash

# init kubernetes 
# kubeadm으로 설치
# token 설정, ttl(Time to live, 유지되는 시간) 0 으로 설정 
# 기본값인 24시간 이후에도 토큰이 계속 유지됨
# 컨테이너에 부여하는 네트워크(사용자 정의) 172.17.0.0/16(172.17.0.1~172.16.255.254)
# API Server IP 설정 (Master Node IP)
kubeadm init --token 123456.1234567890123456 --token-ttl 0 \
--pod-network-cidr=172.17.0.0/16 --apiserver-advertise-address=192.168.1.20

# config for master node only 
# 사용자에게 Kubernetes 권한 주기
# admin.conf 파일을 가지고 있으면 worker node에서도 명령가능 
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# install bash-completion for kubectl 
yum install bash-completion -y 

# kubectl completion on bash-completion dir
kubectl completion bash >/etc/bash_completion.d/kubectl

# alias kubectl to k 
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc