# Kubernetes monitoring

## [Weave scope](https://github.com/weaveworks/scope)

````
kubectl apply -f monitoring/weave-scope.yaml 
````

Get the node port where the app is exposed
````
kubectl get svc --namespace=weave
http://<NODE-IP>:<NODE-PORT>
````


## Prometheus and Grafana

Spin up monitoring services:
````
kubectl apply -f prometheus.yaml
````

To remove monitoring components:
````
kubectl delete namespace monitoring
````

### Import  datasource

Type: Prometheus
URL:  http://prometheus:9090

### Import dashboards

Import grafana dashboards in grafana folder