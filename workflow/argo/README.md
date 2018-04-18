### Install Argo

````
chmod +x argo.sh
./argo.sh
````
Expose the Argo UI:
````
kubectl expose pods <ARGO-UI-POD> -n=kube-system --port=8001 --type=NodePort
````

Try some [examples] (https://github.com/argoproj/argo/tree/master/examples)
````
argo submit <WORKFLOW>
argo submit --serviceaccount <SERVICE-ACCOUNT-NAME> <WORKFLOW>
````


Watch a workflow:
````
watch -n 0.1 argo get <WORKFLOW-NAME>
````

## Examples

# Limit Resources

You are able to limit resources at container level. Argo do not allow to limit resources at workflow level, scheduler will take care of it when resources are available.

# Clean up on success

If you want to clean workflows on success yo may need to add permission to the service account which is executing the workflow. If you execute a workflow on 'default' service account you may need to add permissions:

````
kubectl create clusterrolebinding workflow-delete --clusterrole=cluster-admin --serviceaccount=default:default
````

Above clusterrolebinding adds all permissions stored by cluster-admin to the default serviceaccount. These are too broad. Probably we only want to delete workflows on the default service account (even better on another serviceaccount defined only for this job). Have a look on examples/03-cluster-role.yaml. Here we define a ClusterRole with specific permissions, and it is binded using a ClusterRoleBinding resource.
````
kubectl create -f examples/03-cluster-role.yaml 
````


