```sh
alexey@home:~/epm_kubernets/task4/result$ kubectl apply -f role-deploy-view.yml 
clusterrole.rbac.authorization.k8s.io/deploy_view created
rolebinding.rbac.authorization.k8s.io/binding_deploy_view created
```
```sh
alexey@home:~/epm_kubernets/task4/result$ kubectl apply -f role-deploy-edit.yml 
clusterrole.rbac.authorization.k8s.io/deploy_edit created
rolebinding.rbac.authorization.k8s.io/binding_deploy_edit created
```
