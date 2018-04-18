#!/bin/bash

wget https://github.com/argoproj/argo/releases/download/v2.1.0-beta1/argo-linux-amd64
sudo mv argo-linux-amd64 /usr/local/bin/argo
chmod +x /usr/local/bin/argo
argo install

kubectl create rolebinding default-admin --clusterrole=admin --serviceaccount=default:default
kubectl apply -f argo-ui-deployment.yaml

kubectl create rolebinding default --clusterrole=admin --serviceaccount=default:default