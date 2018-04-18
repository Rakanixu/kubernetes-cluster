# Preemptible VMs

Preemptible VMs are Google Compute Engine VM instances that last a maximum of 24 hours and provide no availability guarantees.

````
gcloud config set container/use_v1_api false
````

### Using node taints to avoid scheduling to preemptible VM nodes

````
kubectl taint nodes <NODE-NAME> cloud.google.com/gke-preemptible="true":NoSchedule
````

Add tolerations to pods / deployments yaml: 
````
tolerations:
- key: cloud.google.com/gke-preemptible
  operator: Equal
  value: "true"
  effect: NoSchedule
````