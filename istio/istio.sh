#!/bin/bash

echo "Downloading istio.."
wget https://github.com/istio/istio/releases/download/0.6.0/istio-0.6.0-linux.tar.gz
tar -xzvf istio-0.6.0-linux.tar.gz
rm istio-0.6.0-linux.tar.gz
cd istio-0.6.0

echo "Installing istio.."
sudo mv bin/istioctl /usr/local/bin/istioctl
kubectl apply -f install/kubernetes/istio.yaml
echo "Addind automatic sidecar injection.."
chmod +x install/kubernetes/webhook-create-signed-cert.sh
chmod +x install/kubernetes/webhook-patch-ca-bundle.sh
./install/kubernetes/webhook-create-signed-cert.sh --service istio-sidecar-injector --namespace istio-system --secret sidecar-injector-certs
kubectl apply -f install/kubernetes/istio-sidecar-injector-configmap-release.yaml
cat install/kubernetes/istio-sidecar-injector.yaml | ./install/kubernetes/webhook-patch-ca-bundle.sh > install/kubernetes/istio-sidecar-injector-with-ca-bundle.yaml
kubectl apply -f install/kubernetes/istio-sidecar-injector-with-ca-bundle.yaml
