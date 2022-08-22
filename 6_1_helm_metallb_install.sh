#!/usr/bin/env bash

# repository url : https://artifacthub.io/
# bitnami/metallb URL : https://artifacthub.io/packages/helm/bitnami/metallb

#repo 추가
helm repo add bitnami https://charts.bitnami.com/bitnami
#repo 업데이트
helm repo update
#metallb 설치 namespace 추가
helm install metallb bitnami/metallb --namespace=metallb-system --create-namespace

echo "metallb install!!"