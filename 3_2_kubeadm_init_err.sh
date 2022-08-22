#!/usr/bin/env bash

# 도커생성시 잘못 생성되었을 때 kubeadm 작동을 안할 경우!
rm -f /etc/containerd/config.toml
systemctl restart containerd

echo "containerd rm and restart!!"