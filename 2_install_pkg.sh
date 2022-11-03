#!/usr/bin/env bash

# yum list docker-ce --showduplicates | sort -r
# yum list docker-ce-cli --showduplicates | sort -r
# yum list containerd.io --showduplicates | sort -r

# yum list kubectl --showduplicates | sort -r
# yum list kubelet --showduplicates | sort -r
# yum list kubeadm --showduplicates | sort -r

#######################################
# install packages 
yum install epel-release -y
yum install vim-enhanced -y
yum install git -y
# https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
yum install netcat -y

#######################################
# nfs install
yum install nfs-utils -y

#######################################
# https://docs.docker.com/engine/install/centos/
# install docker 
# yum install docker-ce-20.10.17-3.el7 docker-ce-cli-20.10.17-3.el7 containerd.io-1.6.7-3.1.el7 -y
# kubernetes 1.24 ~ docker not used
# containerd or CRI-O 
yum install containerd.io-1.6.7-3.1.el7 -y
# systemctl enable --now docker

#######################################
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/#modify-the-kubelet-configmap
# kubernetes v1.22 ~  default(null) -> systemd

# kubectl get cm kubeadm-config  -n kube-system -o yaml > kubeadm-config.yaml
# cat <<EOF | /root/kubeadm-config.yaml
# kind: KubeletConfiguration
# apiVersion: kubelet.config.k8s.io/v1beta1
# cgroupDriver: systemd
# EOF

# kubeadm init --config kubeadm-config.yaml

# kubectl edit cm kubelet-config -n kube-system

# kubectl edit add : cgroupDriver: systemd

#######################################
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md
# customiaing
containerd config default > /etc/containerd/config.toml

#######################################
# https://kubernetes.io/ko/docs/setup/production-environment/container-runtimes/
# systemd setting
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

#######################################
# https://docs.docker.com/engine/install/centos/
# systemd add 
systemctl enable --now containerd

# ERRO[0000] unable to determine runtime API version:
crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock
# ERRO[0000] unable to determine image API version:
crictl config --set image-endpoint=unix:///run/containerd/containerd.sock

#######################################
# install kubernetes cluster
# https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
yum install kubectl-1.25.0-0 kubelet-1.25.0-0 kubeadm-1.25.0-0 --disableexcludes=kubernetes -y
systemctl enable --now kubelet

# yum install kubectl-1.21.9-0 kubelet-1.21.9-0 kubeadm-1.21.9-0 -y

#######################################
# install kubernetes cluster
# single node pod (master node) create pod
# $ kubectl taint nodes --all node-role.kubernetes.io/master-

