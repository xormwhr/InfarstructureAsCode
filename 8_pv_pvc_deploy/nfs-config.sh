#!/usr/bin/env bash

# dir create
mkdir /nfs_shared

# nfs install
yum install nfs-utils -y

# exports 설정
# rw : 읽기/쓰기
# sync : 쓰기 작업 동기화
# no_root_squash : root 계정 사용
echo '/nfs_shared 192.168.1.0/24(rw,sync,no_root_squash)' >> /etc/exports

# nfs 자동으로 활성화
systemctl enable --now nfs

