# 1
kubelete
-- ensures that the containers described in those PodSpecs are running and healthy.
https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/

# 2
## Configuration
```
kubectl create ns task2
kubectl apply -n task2 -f web_canary_deployment.yml
kubectl apply -n task2 -f web_canary_deployment_v2.yml 
kubectl apply -n task2 -f ingress-v1.yaml
kubectl apply -n task2 -f ingress-v2.yaml
kubectl apply -n task2 -f ingress-partial.yaml
```
```
alexey@home:~/epm_kubernets/task2/result$ kubectl get -n task2 all
NAME                                            READY   STATUS    RESTARTS   AGE
pod/canary-deployment-web-v1-5b44777d84-7bpxt   1/1     Running   0          16m
pod/canary-deployment-web-v1-5b44777d84-hm72v   1/1     Running   0          16m
pod/canary-deployment-web-v1-5b44777d84-mrbgv   1/1     Running   0          16m
pod/canary-deployment-web-v2-547d49748-gwb6f    1/1     Running   0          15m
pod/canary-deployment-web-v2-547d49748-k2ddz    1/1     Running   0          15m
pod/canary-deployment-web-v2-547d49748-pvhlm    1/1     Running   0          15m

NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/canary-service-web-v1   ClusterIP   10.100.136.15    <none>        80/TCP    16m
service/canary-service-web-v2   ClusterIP   10.103.162.173   <none>        80/TCP    15m

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/canary-deployment-web-v1   3/3     3            3           16m
deployment.apps/canary-deployment-web-v2   3/3     3            3           15m

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/canary-deployment-web-v1-5b44777d84   3         3         3       16m
replicaset.apps/canary-deployment-web-v2-547d49748    3         3         3       15m
```

## Result
```
for i in $(seq 1 10); do curl -H 'canary:example' http://$(minikube ip); done
canary-deployment-web-v1-5b44777d84-jhhrp
 response from V1canary-deployment-web-v2-547d49748-dz9c4 EDGE application
web-5584c6c5c6-qs58j
canary-deployment-web-v1-5b44777d84-76djw
 response from V1web-5584c6c5c6-xh8jj
canary-deployment-web-v2-547d49748-s6ttw EDGE application
web-5584c6c5c6-ht7wg
canary-deployment-web-v1-5b44777d84-64tkc
 response from V1canary-deployment-web-v2-547d49748-dz9c4 EDGE application
web-5584c6c5c6-qs58j
```
