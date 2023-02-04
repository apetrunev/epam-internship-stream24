#!/bin/sh

# create Account, Role, RoleBinding
kubectl apply -f sa.yml

TOKEN_NAME=$(kubectl get sa sa-namespace-admin -o jsonpath="{.secrets[0].name}")
TOKEN=$(kubectl -n default get secret $TOKEN_NAME -o jsonpath="{.data.token}" | base64 --decode)

curl -k -H "Authorization: Bearer $TOKEN" -X GET "https://$(minikube ip)/api/v1/nodes/" | json_pp
# Add service account to kubeconfig
kubectl config set-credentials sa-namespace-admin --token=$TOKEN
kubectl config set-context sa-namespace-admin --cluster=minikube --user=sa-namespace-admin

