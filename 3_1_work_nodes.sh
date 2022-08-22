#!/usr/bin/env bash

# config for work_nodes only 
# kubeadm 사용해 Master Node 접속
# 토큰은 Master Node에서 생성한 것을 사용
# 인증을 무시하고 API Server IP , 6443 기본포트로 접속 
kubeadm join --token 123456.1234567890123456 \
             --discovery-token-unsafe-skip-ca-verification 192.168.1.20:6443