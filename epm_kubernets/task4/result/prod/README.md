```sh
./install.sh
kubectl create ns prod
kubectl config set-context prod_view --cluster=minikube --user=prod_view --namespace=prod
kubectl config set-context prod_admin --cluster=minikube --user=prod_admin --namespace=prod
```
