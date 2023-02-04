# Task 1.1

## Verify Versionn:
```
alexey@home:/tmp$ kubectl version --client --output=yaml
clientVersion:
  buildDate: "2022-03-16T15:58:47Z"
  compiler: gc
  gitCommit: c285e781331a3785a7f436042c65c5641ce8a9e9
  gitTreeState: clean
  gitVersion: v1.23.5
  goVersion: go1.17.8
  major: "1"
  minor: "23"
  platform: linux/amd64
```
## Start minikube cluster
```
alexey@home:/tmp$ minikube start --driver=virtualbox
😄  minikube v1.23.2 on Debian 10.11
✨  Using the virtualbox driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🔥  Creating virtualbox VM (CPUs=2, Memory=2200MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.22.2 on Docker 20.10.8 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
🔎  Verifying Kubernetes components...
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```
## Get information about custer
```
alexey@home:/tmp$ kubectl cluster-info
Kubernetes control plane is running at https://192.168.99.101:8443
CoreDNS is running at https://192.168.99.101:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
## Get information about available nodes
```
alexey@home:/tmp$ kubectl get nodes
NAME       STATUS   ROLES                  AGE     VERSION
minikube   Ready    control-plane,master   2m57s   v1.22.2
```
## Install Kubernetes bashboard
```
alexey@home:/tmp$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
namespace/kubernetes-dashboard created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
Warning: spec.template.metadata.annotations[seccomp.security.alpha.kubernetes.io/pod]: deprecated since v1.19; use the "seccompProfile" field instead
deployment.apps/dashboard-metrics-scraper created
```
## Check kubernets-dashboard ns
```
alexey@home:/tmp$ kubectl get pod -n kubernetes-dashboard
NAME                                         READY   STATUS    RESTARTS   AGE
dashboard-metrics-scraper-856586f554-8rmk4   1/1     Running   0          34s
kubernetes-dashboard-67484c44f6-52xrs        1/1     Running   0          34s
```
## Install Metrics Server
```
alexey@home:/tmp$ kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
serviceaccount/metrics-server created
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
clusterrole.rbac.authorization.k8s.io/system:metrics-server created
rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader created
clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator created
clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server created
service/metrics-server created
deployment.apps/metrics-server created
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
```
## Update deployment
![alt text](https://github.com/apetrunev/epm_kubernets/blob/master/task1/kubernetes_before_edit.png)
![alt_text](https://github.com/apetrunev/epm_kubernets/blob/master/task1/kubernetes_after_edit.png)

## Get token
```
alexey@home:/tmp$ kubectl describe sa -n kube-system default
Name:                default
Namespace:           kube-system
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   default-token-6hkr2
Tokens:              default-token-6hkr2
Events:              <none>

alexey@home:/tmp$ kubectl get secrets -n kube-system
NAME                                             TYPE                                  DATA   AGE
...
default-token-6hkr2                              kubernetes.io/service-account-token   3      13m
...

kubectl get secrets -n kube-system default-token-6hkr2 -o yaml
apiVersion: v1
data:
  ca.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCakNDQWU2Z0F3SUJBZ0lCQVRBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwdGFXNXAKYTNWaVpVTkJNQjRYRFRJeU1EUXdNVEl5TXpNeU1sb1hEVE15TURNek1ESXlNek15TWxvd0ZURVRNQkVHQTFVRQpBeE1LYldsdWFXdDFZbVZEUVRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT1VVCmkzaGYyRE9WQk5kb3Z0SlZOUmtTMzgxWEtkdzBHNWdNSm15MUZ3VzlZWURiVWw2YUVrcWI4bVhKRkJ3a3ZGWFMKdTdYZUZKcURESzRCMDdBbU51bmdPU2NTNEJmbWx4SzZGVjkxd1F4U1p6cG9QQ0JPWEE4bzlKZEJlYzZpZ1JkVgpXMEo3WS9XSXgrRDBPeVpGRzJLS0ZwMC9uRTRHWEYwdWNQYkNjL3grNFdHY2l6V21LYkgvNnF3YmtkU1kydElnClRQZVpqSDQyT201TXJma0dUMVNYS3pHT3BVUWFmK252UmFGS2xLVzMwNnI3NFBGMmlNRDc2S1RhdHlVWHBxYk4KZVNRR2pyejJHVGVPNkxmS0Z1cDVGNzVGamZEUzhJN2sza0R2VmJ5RDJTd2ErYUZhZXBTejdQVGpWUFlRRnVxNwp1TFoyeGJFMTBROU0zbDB5WEFrQ0F3RUFBYU5oTUY4d0RnWURWUjBQQVFIL0JBUURBZ0trTUIwR0ExVWRKUVFXCk1CUUdDQ3NHQVFVRkJ3TUNCZ2dyQmdFRkJRY0RBVEFQQmdOVkhSTUJBZjhFQlRBREFRSC9NQjBHQTFVZERnUVcKQkJSdTNWZXFoYzhDK1pYYnFRd21lamlqdHQwTzh6QU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFNY3pscGpSagpjOTkyVzk4OVVwMFloM3o3OTJrVkhvTFJYcGJyNnRIN2pUcEk5MHJkMTBrUjlWQ2JOVTl1T3B6NzZuTHhmVEVNCkIwMkRjOTQ4WUdhc2hDS1JkS0U3RnhnYlQxSklzazRlZHBKMGlOMzc0Z3FZWlRRQ2QxTWJUZU85aDByN3c2SXIKK3N6U1hUdUdXR2h6RG1mdmlsYnl0N2t4cTZaalN4N1ZXT3g1a2pPbWNaTG1SeXRCQWVyTzd6aXNaL0s0d1VFWQpVeUFteVRYN3pvcHU2cStmTnpYdU5tZXo0RkwyY1ZzSFQ0Mmt2OUlpejNoWm0vOEhtNVN2cVNBZGZFeEx5N3ptCnZDQlFsODRFenUxZFpadGhNNFBjUHlLQTBvRkROeTN2cHQzQzBRbmlDU3V0c09Jb3FTUEtNaVZZOHZKRE5hbHMKeERIejNwekxpaWJkdnc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
  namespace: a3ViZS1zeXN0ZW0=
  token: ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkltUjBTVTFVZEhZNU5HaElNVlJwUzA1SFFYYzVMV1pmV205eFZYbGpVbGd6TjFaWmNrVk9SWEEyY2tVaWZRLmV5SnBjM01pT2lKcmRXSmxjbTVsZEdWekwzTmxjblpwWTJWaFkyTnZkVzUwSWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXVZVzFsYzNCaFkyVWlPaUpyZFdKbExYTjVjM1JsYlNJc0ltdDFZbVZ5Ym1WMFpYTXVhVzh2YzJWeWRtbGpaV0ZqWTI5MWJuUXZjMlZqY21WMExtNWhiV1VpT2lKa1pXWmhkV3gwTFhSdmEyVnVMVFpvYTNJeUlpd2lhM1ZpWlhKdVpYUmxjeTVwYnk5elpYSjJhV05sWVdOamIzVnVkQzl6WlhKMmFXTmxMV0ZqWTI5MWJuUXVibUZ0WlNJNkltUmxabUYxYkhRaUxDSnJkV0psY201bGRHVnpMbWx2TDNObGNuWnBZMlZoWTJOdmRXNTBMM05sY25acFkyVXRZV05qYjNWdWRDNTFhV1FpT2lKa09EY3hNelF4TmkweU9UbGlMVFF3TWpJdE9HRTJOeTFoWm1Fd04yRTBNamxpTlRRaUxDSnpkV0lpT2lKemVYTjBaVzA2YzJWeWRtbGpaV0ZqWTI5MWJuUTZhM1ZpWlMxemVYTjBaVzA2WkdWbVlYVnNkQ0o5LnZBZzNQZm42cF80MkthczBBbG9EczhXQ2JuRFdjQVFzbWhiYjAzSERaSlZfbG4tRmZZdEFCMTJENTE5RjZoajRzRm1xMzZqaUc5eS1wLWVNVDdsNXczMmc0RE43R2RNUTM1UEhud1BlWjd4ZjJrY0NaR01jQ0RGNXVaWVBjeVhIeWZRWGtpNDZkaXhKalR3cVJHV1pHbDY1N1ZxVi1VVUF1c1RzdEpILU9nbnVXVlpFR1F1a0NUVGUxamV2X3pxN2ZnMzVWVnY2dmI2Ump1SEhySk9MTTZHWklLVkRhSDlLXzhMSG5OUlAyZktpM3lVQUlieFZ0S1YzZDBPTk9JaFBkemNReEpHTEpGeW01RDlDLVdoT3FTeUp2UldscndUa1V3WEFZWUVqYVVGUUxRUTYwTjNDX1pxRGh3WTJMZW95Y1h4V2xJLWxBUDFENlR5RW5Ua01iQQ==
kind: Secret
metadata:
  annotations:
    kubernetes.io/service-account.name: default
    kubernetes.io/service-account.uid: d8713416-299b-4022-8a67-afa07a429b54
  creationTimestamp: "2022-04-02T23:26:01Z"
  name: default-token-6hkr2
  namespace: kube-system
  resourceVersion: "406"
  uid: 27bfd322-a5d4-436c-8c7a-f8b828fcb072
type: kubernetes.io/service-account-token

alexey@home:/tmp$ echo -n "ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkltUjBTVTFVZEhZNU5HaElNVlJwUzA1SFFYYzVMV1pmV205eFZYbGpVbGd6TjFaWmNrVk9SWEEyY2tVaWZRLmV5SnBjM01pT2lKcmRXSmxjbTVsZEdWekwzTmxjblpwWTJWaFkyTnZkVzUwSWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXVZVzFsYzNCaFkyVWlPaUpyZFdKbExYTjVjM1JsYlNJc0ltdDFZbVZ5Ym1WMFpYTXVhVzh2YzJWeWRtbGpaV0ZqWTI5MWJuUXZjMlZqY21WMExtNWhiV1VpT2lKa1pXWmhkV3gwTFhSdmEyVnVMVFpvYTNJeUlpd2lhM1ZpWlhKdVpYUmxjeTVwYnk5elpYSjJhV05sWVdOamIzVnVkQzl6WlhKMmFXTmxMV0ZqWTI5MWJuUXVibUZ0WlNJNkltUmxabUYxYkhRaUxDSnJkV0psY201bGRHVnpMbWx2TDNObGNuWnBZMlZoWTJOdmRXNTBMM05sY25acFkyVXRZV05qYjNWdWRDNTFhV1FpT2lKa09EY3hNelF4TmkweU9UbGlMVFF3TWpJdE9HRTJOeTFoWm1Fd04yRTBNamxpTlRRaUxDSnpkV0lpT2lKemVYTjBaVzA2YzJWeWRtbGpaV0ZqWTI5MWJuUTZhM1ZpWlMxemVYTjBaVzA2WkdWbVlYVnNkQ0o5LnZBZzNQZm42cF80MkthczBBbG9EczhXQ2JuRFdjQVFzbWhiYjAzSERaSlZfbG4tRmZZdEFCMTJENTE5RjZoajRzRm1xMzZqaUc5eS1wLWVNVDdsNXczMmc0RE43R2RNUTM1UEhud1BlWjd4ZjJrY0NaR01jQ0RGNXVaWVBjeVhIeWZRWGtpNDZkaXhKalR3cVJHV1pHbDY1N1ZxVi1VVUF1c1RzdEpILU9nbnVXVlpFR1F1a0NUVGUxamV2X3pxN2ZnMzVWVnY2dmI2Ump1SEhySk9MTTZHWklLVkRhSDlLXzhMSG5OUlAyZktpM3lVQUlieFZ0S1YzZDBPTk9JaFBkemNReEpHTEpGeW01RDlDLVdoT3FTeUp2UldscndUa1V3WEFZWUVqYVVGUUxRUTYwTjNDX1pxRGh3WTJMZW95Y1h4V2xJLWxBUDFENlR5RW5Ua01iQQ==" | base64 -d
eyJhbGciOiJSUzI1NiIsImtpZCI6ImR0SU1UdHY5NGhIMVRpS05HQXc5LWZfWm9xVXljUlgzN1ZZckVORXA2ckUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkZWZhdWx0LXRva2VuLTZoa3IyIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImRlZmF1bHQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJkODcxMzQxNi0yOTliLTQwMjItOGE2Ny1hZmEwN2E0MjliNTQiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06ZGVmYXVsdCJ9.vAg3Pfn6p_42Kas0AloDs8WCbnDWcAQsmhbb03HDZJV_ln-FfYtAB12D519F6hj4sFmq36jiG9y-p-eMT7l5w32g4DN7GdMQ35PHnwPeZ7xf2kcCZGMcCDF5uZYPcyXHyfQXki46dixJjTwqRGWZGl657VqV-UUAusTstJH-OgnuWVZEGQukCTTe1jev_zq7fg35VVv6vb6RjuHHrJOLM6GZIKVDaH9K_8LHnNRP2fKi3yUAIbxVtKV3d0ONOIhPdzcQxJGLJFym5D9C-WhOqSyJvRWlrwTkUwXAYYEja
```
## Auto
```
alexey@home:/tmp$ export SECRET_NAME=$(kubectl get sa -n kube-system default -o jsonpath='{.secrets[0].name}')
alexey@home:/tmp$ echo $SECRET_NAME
default-token-6hkr2

alexey@home:/tmp$ export TOKEN=$(kubectl get secrets -n kube-system $SECRET_NAME -o jsonpath='{.data.token}' | base64 -d)
alexey@home:/tmp$ echo $TOKEN
eyJhbGciOiJSUzI1NiIsImtpZCI6ImR0SU1UdHY5NGhIMVRpS05HQXc5LWZfWm9xVXljUlgzN1ZZckVORXA2ckUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkZWZhdWx0LXRva2VuLTZoa3IyIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImRlZmF1bHQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJkODcxMzQxNi0yOTliLTQwMjItOGE2Ny1hZmEwN2E0MjliNTQiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06ZGVmYXVsdCJ9.vAg3Pfn6p_42Kas0AloDs8WCbnDWcAQsmhbb03HDZJV_ln-FfYtAB12D519F6hj4sFmq36jiG9y-p-eMT7l5w32g4DN7GdMQ35PHnwPeZ7xf2kcCZGMcCDF5uZYPcyXHyfQXki46dixJjTwqRGWZGl657VqV-UUAusTstJH-OgnuWVZEGQukCTTe1jev_zq7fg35VVv6vb6RjuHHrJOLM6GZIKVDaH9K_8LHnNRP2fKi3yUAIbxVtKV3d0ONOIhPdzcQxJGLJFym5D9C-WhOqSyJvRWlrwTkUwXAYYEjaUFQLQQ60N3C_ZqDhwY2LeoycXxWlI-lAP1D6TyEnTkMbA
```
# Task 1.2
```
alexey@home:/tmp$ kubectl run web --image=nginx:latest
pod/web created
```
## Apply manifests
```
alexey@home:~/epm_kubernets/task1$ kubectl apply -f pod.yaml 
pod/nginx created
alexey@home:~/epm_kubernets/task1$ kubectl apply -f rs.yaml 
replicaset.apps/webreplica created
```
## Look at pod
```
alexey@home:~/epm_kubernets/task1$ kubectl get pod
NAME               READY   STATUS    RESTARTS   AGE
nginx              1/1     Running   0          18s
web                1/1     Running   0          3m3s
webreplica-8kxk5   1/1     Running   0          13s
```
## Create a deployment nginx.
```
alexey@home:~/epm_kubernets/task1$ kubectl create deployment nginx --image=nginx --replicas=2
deployment.apps/nginx created
alexey@home:~/epm_kubernets/task1$ kubectl get pod
NAME                     READY   STATUS              RESTARTS   AGE
nginx                    1/1     Running             0          119s
nginx-6799fc88d8-kbhdp   1/1     Running             0          5s
nginx-6799fc88d8-sfhm7   0/1     ContainerCreating   0          5s
web                      1/1     Running             0          4m44s
webreplica-8kxk5         1/1     Running             0          114s
alexey@home:~/epm_kubernets/task1$ kubectl get pod
NAME                     READY   STATUS    RESTARTS   AGE
nginx                    1/1     Running   0          2m5s
nginx-6799fc88d8-kbhdp   1/1     Running   0          11s
nginx-6799fc88d8-sfhm7   1/1     Running   0          11s
web                      1/1     Running   0          4m50s
webreplica-8kxk5         1/1     Running   0          2m

alexey@home:~/epm_kubernets/task1$ kubectl delete pod nginx-6799fc88d8-kbhdp && kubectl get pods
pod "nginx-6799fc88d8-kbhdp" deleted
NAME                     READY   STATUS              RESTARTS   AGE
nginx                    1/1     Running             0          3m26s
nginx-6799fc88d8-nkmj7   0/1     ContainerCreating   0          1s
nginx-6799fc88d8-sfhm7   1/1     Running             0          92s
web                      1/1     Running             0          6m11s
webreplica-8kxk5         1/1     Running             0          3m21s

alexey@home:~/epm_kubernets/task1$ kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
nginx                    1/1     Running   0          3m56s
nginx-6799fc88d8-nkmj7   1/1     Running   0          31s
nginx-6799fc88d8-sfhm7   1/1     Running   0          2m2s
web                      1/1     Running   0          6m41s
webreplica-8kxk5         1/1     Running   0          3m51s
```
