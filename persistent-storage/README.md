# PersistentVolume for Storage


## NFS

An implmentation of storage is required, in this case NFS. 
Have a look on the nfs folder to deploy a Network File System inside your cluster.

Have a look on nfs-persistent-volume.yaml, subtitute the IP address in spec.nfs.server for you NFS server address. Substitute spec.nfs.server by your volume path.

To provide a static PersistentVolume, a couple of PersistentVolumeClaim and claim them in a deployment:
````
kubectl apply -f nfs/nfs-persistent-volume.yaml
````