# S3 object storage

### Prerequsites

Mount a NFS host and clients on the nodes where you will deploy minio nodes.

# Deploy minio

Label all nodes where minio will run:
````
kubectl label nodes <NODE-NAMES> nfs=mounted
kubectl label nodes ubuntu ubuntu2 nfs=mounted
````

Check node labels:
````
kubectl get nodes --show-labels
````

Deploy standalone minio.
´´´´
kubectl apply -f minio-s3-standalone.yaml
´´´´

Deploy distributed minio:
´´´´
kubectl apply -f minio-s3-distributed.yaml
´´´´
