# GlusterFS - DINAMIC PROVISIONING

````
chmod +x glusterfs.sh
./glusterfs.sh <STORAGE-NODE-NAME> ...
./glusterfs.sh ubuntu ubuntu2
````

# Mount a Network File System in the cluster nodes - NO DINAMIC PROVISIONING

It's supposed that no firewall is in place on the cluster machines, to check it:
````
sudo ufw status
````

If it is active, then you should allow the access to the host from client machines:
````
sudo ufw allow from <CLIENT-NODE> to any port nfs
````


1. To mount a share directory in the host machine:
````
chmod +x nfs.sh
./nfs.sh host <CLIENT-NODE-IP> ... <CLIENT-NODE-IP-N>
./nfs.sh host 192.168.0.178 192.168.0.179
````

2. To provide access to the shared directory in a client machine:
````
chmod +x nfs.sh
./nfs.sh client <HOST-IP>
./nfs.sh client 192.168.0.146
````

# Mounting volumes

You can access NFS by mounting volumes on the deployments. 
´´´´
kubectl apply -f nfs/nfs-persistent-volume.yaml
´´´´
