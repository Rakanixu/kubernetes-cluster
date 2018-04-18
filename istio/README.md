# Install Istio

Automatic sidecar injection is enabled by default. This will allow to deploy your services using kubectl. 
````
chmod +x istio.sh
./istio.sh
````

If automatic sidecar injection is not enable or not running, then:
````
kubectl create -f <(istioctl kube-inject -f <your-app-spec>.yaml)
````
