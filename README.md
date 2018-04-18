### Install kubernetes

## Master node
````
chmod +x kubernetes-cluster.sh
./kubernetes-cluster.sh master
````

## Worker node
````
chmod +x kubernetes-cluster.sh
./kubernetes-cluster.sh
````

or

````
./kubernetes-cluster worker
````

## Next steps
1. Check nodes in the cluster
````
kubectl get nodes
````

2. Define a deployment
````
wget https://raw.githubusercontent.com/kubernetes/website/master/docs/tasks/run-application/deployment.yaml
kubectl apply -f deployment.yaml
````

3. Expose a service
````
kubectl expose -f deployment.yaml --port=9000 --target-port=80  --type=NodePort
kubectl expose pods <POD-NAME> --namespace=<POD-NAMESPACE> --port=<LOCAL-PORT> --target-port=<POD-PORT> --type=NodePort

kubectl get services
````

4. Check service availability outside the cluster (inside another pod kube-dns will resolve 'nginx-deployment' to the nginx service):
````
curl <CLUSTER-IP>:9000
curl <NODE-IP>:<NODE-PORT>
````

````
kubectl get pods --all-namespaces
````

## Dismantle cluster
````
kubectl drain <NODE NAME> --delete-local-data --force --ignore-daemonsets
kubectl delete node <NODE NAME>
kubeadm reset
````

After a reset flannel interface may be up, to fix it:
````
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /run/flannel
rm -rf /etc/cni/
ifconfig cni0 down
ifconfig flannel.1 down
ifconfig docker0 down
ip link delete cni0
ip link delete flannel.1
systemctl start docker
````


If there is a prblem when joining the cluster, be sure to have NTPD installed to sync the cluster:
````
apt-get install ntp
````



## Useful commands:
- Get join command to execute in a node:
````
kubeadm token create --print-join-command
````

- Add a node to the cluster:
````
kubeadm join --token <TOKEN> <EXTERNAL-IP-MASTER-NODE>:6443 --discovery-token-ca-cert-hash sha256:<DISCOVERTY-TOKEN>
````

- Enable schedule pods on master node:
````
kubectl taint nodes --all node-role.kubernetes.io/master-
````

- Enable proxy API server to localhost:
````
kubectl proxy --port=8080
curl http://localhost:8080/api/v1
````

- Check all pods in cluster:
````
kubectl get pods --all-namespaces
````

- Remove crashing pods, deployment will be rescheduled:
````
kubectl delete pod `kubectl get pods | awk '$3 == "CrashLoopBackOff" {print $1}'`
````

- Forward pod port to local port:
````
kubectl port-forward --namespace=<POD-NAMESPACE> <POD-NAME> <POD-PORT>:<LOCAL-PORT>
````

- Get a list of kubernetes events for debugging purposes:
````
kubectl get events
````

-Get YAML / JSON definition for a resource:
````
kubectl -oymal get <RESOURCE> <RESOURCE-NAME>
kubectl -ojson get <RESOURCE> <RESOURCE-NAME>
kubectl -oymal get workflow coinflip-v58vg
````