#!/bin/bash

echo "Downloading NFS components.."
sudo apt-get update

if [ "$1" = "host" ]
then
  sudo apt-get install nfs-kernel-server -y
  sudo mkdir /storage -p
  sudo chown nobody:nogroup /var/storage

  shift
  for IP in "$@"; do
    echo "Allowing address $IP to share volume /storage"
    echo "/storage $IP(rw,sync,no_root_squash,no_subtree_check)" | sudo tee --append /etc/exports
  done

  echo "Restariting NFS server.."
  sudo systemctl restart nfs-kernel-server
elif [ "$1" = "client" ]
then
  sudo apt-get install nfs-common -y
  sudo mkdir -p /storage
  echo "Mounting $2:/storage into /storage"
  sudo mount $2:/storage /storage
else 
  echo "No argument provided, exiting.."
  exit
fi


