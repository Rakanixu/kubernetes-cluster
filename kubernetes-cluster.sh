#!/bin/bash

echo "Installing docker.."
sudo apt-get -y install docker.io
echo "Enabling docker service.."
sudo systemctl enable docker.service

echo "Downloading kubectl.."
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod u+x kubectl
sudo mv kubectl /usr/local/bin/kubectl

echo "Downloading kubeadm.."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo add-apt-repository 'deb http://apt.kubernetes.io/ kubernetes-xenial main'
sudo apt-get update
sudo apt-get install -y kubelet kubeadm

echo "Disabling swap memory.."
sudo swapoff -a

if [ "$1" = "master" ]
then
  echo "Initializing master node.."
  sudo kubeadm init --pod-network-cidr=10.244.0.0/16
  sudo sysctl net.bridge.bridge-nf-call-iptables=1
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  echo "Deploying pod network.."
  wget https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
  kubectl apply -f kube-flannel.yml
else
  echo "----------------------------------------------------------------"
  echo "|                                                              |"
  echo "| To join worker node to cluster follow instructions above     |"
  echo "|                                                              |"
  echo "| kubeadm join --token <TOKEN> <EXTERNAL-IP-MASTER-NODE>:6443  |"
  echo "|     --discovery-token-ca-cert-hash sha256:<DISCOVERTY-TOKEN> |"
  echo "|                                                              |"
  echo "----------------------------------------------------------------"
fi

