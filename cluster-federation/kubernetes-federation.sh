#!/bin/bash

sudo cp kubefed /usr/local/bin/kubefed
sudo chmod +x /usr/local/bin/kubefed

if [ "$1" = "host" ]; then
  if [ "$2" != "" ]; then
    echo "Donloading helm.." 
    wget  https://storage.googleapis.com/kubernetes-helm/helm-v2.8.2-linux-amd64.tar.gz
    tar -xzvf helm-v2.8.2-linux-amd64.tar.gz 
    sudo cp linux-amd64/helm /usr/local/bin/helm
    rm -rf linux-amd64
    kubectl create serviceaccount --namespace kube-system tiller
    kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller  
    helm init --service-account tiller --upgrade
    kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'    
    helm install --namespace etcd --name etcd-operator stable/etcd-operator
    helm upgrade --namespace etcd --set cluster.enabled=true etcd-operator stable/etcd-operator
    # curl  http://etcd-cluster.etcd:2379 
    helm install --namespace etcd --name coredns -f coredns-values.yaml stable/coredns
    NODE_PORT=$(kubectl get --namespace etcd -o jsonpath="{.spec.ports[0].nodePort}" services coredns-coredns)
    NODE_IP=$(kubectl get nodes --namespace etcd -o jsonpath="{.items[0].status.addresses[0].address}")
    echo "coreDNS is available at $NODE_IP:$NODE_PORT"


    #echo "Preparing to use CoreDNS.."
    #sudo kubeadm upgrade plan  --feature-gates CoreDNS=true
    #sudo kubeadm upgrade apply v1.9.6 --feature-gates CoreDNS=true -y

    UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16);
    # --api-server-service-type=NodePort flag for bare-metal / on-premises cluster
    # This flag will expose the federation API in a NodePort service
    echo "Initializing federation control plane.."
    #kubefed init k8-federate-host-$UUID --host-cluster-context=$2 --api-server-service-type=NodePort --dns-provider="coredns"  --dns-zone-name="example.com." --dns-provider-config=coredns-provider.conf
    #kubefed init k8federate --host-cluster-context="kubernetes-admin@kubernetes" --dns-provider="google-clouddns" --dns-zone-name="epick8.com." --api-server-service-type="NodePort"
    kubefed init k8federate --host-cluster-context="kubernetes-admin@kubernetes" --dns-provider="coredns" --dns-zone-name="example.com." --api-server-service-type="NodePort" --dns-provider-config="coredns-provider.conf"
  else 
    echo "Host cluster context required, exiting.."
    exit
  fi
else
  echo "---"
fi
