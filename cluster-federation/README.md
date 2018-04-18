# Cluster federation

## Google Cloud

Define two clusters in google cloud and connect to both of them with *gcloud*.
Get all available contexts:
````
kubectl config get-contexts
```` 

Before executing kubefed, grant yoour user with permissions to create roles:
````
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)
````

Choose the host cluster from the name:
````
kubefed init <HOST-CLUSTER-NAME> --host-cluster-context=<HOST-CONTEXT-NAME> --dns-provider="google-clouddns" --dns-zone-name=<MANAGED-DNS-ZONE-NAME>
kubefed init epicfederation --host-cluster-context=gke_ageless-aleph-200009_europe-west1-b_kubernetes01 --dns-provider="google-clouddns" --dns-zone-name="k8.epiclabs.io." --apiserver-enable-basic-auth=true --etcd-persistent-storage=false --apiserver-arg-overrides="--anonymous-auth=false,--v=4"
````

# Remove cluster from federation

````
kubefed unjoin gondor --host-cluster-context=<HOST-CLUSTER-NAME>
kubefed unjoin gondor --host-cluster-context=epicfederation
````


# Turning down federation control plane

````
kubectl delete namespace federation-system --context=<HOST-CLUSTER-NAME>
kubectl delete namespace federation-system --context=epicfederation
````

## On premises / bare metal

### Host cluster

You’ll need to choose one of your Kubernetes clusters to be the host cluster. The host cluster hosts the components that make up your federation control plane.

Get all available contexts:
````
kubectl config get-contexts
```` 

From the list of all context, choose one:
````
chmod +x kubernetes-federation.sh
./kubernetes-federation.sh host <CONTEXT-NAME>
./kubernetes-federation.sh host kubernetes-admin@kubernetes
````

### Adding a cluster to a deferation