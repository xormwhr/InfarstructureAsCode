#!/usr/bin/env bash

#######################################
# vim configuration 
# vim -> vi alias (highlight)
echo 'alias vi=vim' >> /etc/profile

#######################################
# swapoff -a to disable swapping
# swap off
swapoff -a
# sed to comment the swap partition in /etc/fstab
# /etc/fstab -> /etc/fstab /etc/fstab.bak
# /swapfile none swap defaults 0 0 -> # /swapfile none swap defaults 0 0
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

#######################################
# https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# kubernetes repo
gg_pkg="packages.cloud.google.com/yum/doc" # Due to shorten addr for key
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://${gg_pkg}/yum-key.gpg https://${gg_pkg}/rpm-package-key.gpg
EOF

#######################################
# https://docs.docker.com/engine/install/centos/
# docker repo
yum install yum-utils -y 
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#######################################
# https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# Set SELinux in permissive mode (effectively disabling it)
# SELinux off
setenforce 0
#enforcing -> permissive
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

#######################################
# firewalld off
systemctl stop firewalld
# firewalld systemd disable
systemctl disable firewalld

#######################################
# https://kubernetes.io/ko/docs/setup/production-environment/container-runtimes/
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# br_netfilter 커널 모듈을 사용해 브리지로 네트워크를 구성
# IP 마스커레이드(Masquerade)를 사용해 내부 네트워크와 외부 네트워크를 분리
# IP 마스커레이드는 커널에서 제공하는 NAT(Network Address Translation)
# br_netfilter를 적용함으로써 위의 iptables가 활성화
modprobe br_netfilter
modprobe overlay

# 브리지 네트워크를 통과하는 IPv4와 IPv6의 패킷을 iptables가 관리하도록 설정
# 파드의 통신을 iptables로 제어
# 필요에 따라 IPVS(IP Virtual Server)같은 방식으로도 구성
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

#######################################
# IP -> IP, Host name
echo "192.168.1.20 m-k8s" >> /etc/hosts
for (( i=1; i<=2; i++  )); do echo "192.168.1.20$i w$i-k8s" >> /etc/hosts; done

#######################################
# config DNS  
cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1 #cloudflare DNS
nameserver 8.8.8.8 #Google DNS
EOF
