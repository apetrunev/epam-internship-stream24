## 1. We published minio "outside" using nodePort. Do the same but using ingress.
```
kubectl apply -f minio-svc.yml
kubectl apply -f ingress.yml
curl -I http://$(minikube ip)
```
## 2. Publish minio via ingress so that minio by ip_minikube and nginx returning hostname (previous job) by path ip_minikube/web are available at the same time.
```
kubectl apply -f deployment.yml
kubectl expose deployment nginx-app --port=80 --type=ClusterIP
kubectl apply -f minio-ingress.yml
kubectl apply -f nginx-ingress.yml
curl -I http://$(minikube ip)
curl -I http://$(minikube ip)/web
```
## 3. Create deploy with emptyDir save data to mountPoint emptyDir, delete pods, check data.
```
kubectl apply -f deploy-empty-dir.yml
kubectl exec -it pod-empty-dir-75d6d845c5-5856s -c nginx-empty -- touch /opt/data-one/file.txt
```
Check data:
```
alexey@home:~/epm_kubernets/task3/result$ kubectl exec -it pod-empty-dir-75d6d845c5-5856s -c debian-empty -- ls -la /opt/data-second
total 8
drwxrwxrwx 2 root root 4096 Apr  9 12:46 .
drwxr-xr-x 1 root root 4096 Apr  9 12:45 ..
-rw-r--r-- 1 root root    0 Apr  9 12:46 file.txt
```
Scale down and the up:
```
alexey@home:~/epm_kubernets/task3/result$ kubectl scale deployment pod-empty-dir --replicas 0
deployment.apps/pod-empty-dir scaled
```
```
alexey@home:~/epm_kubernets/task3/result$ kubectl scale deployment pod-empty-dir --replicas 1
deployment.apps/pod-empty-dir scaled
```
Check data again:
```
alexey@home:~/epm_kubernets/task3/result$ kubectl exec -it pod-empty-dir-75d6d845c5-2jdq5 -c debian-empty -- ls -la /opt/data-second
total 8
drwxrwxrwx 2 root root 4096 Apr  9 12:49 .
drwxr-xr-x 1 root root 4096 Apr  9 12:49 ..
```
