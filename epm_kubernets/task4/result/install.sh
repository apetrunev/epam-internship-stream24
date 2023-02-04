#!/bin/sh -x

CA_DIR=$HOME/.minikube

for KUSER in deploy_view deploy_edit; do
  # generate private key
  openssl genrsa -out $KUSER.key 2048
  # renerate cert sign request
  openssl req -new -key $KUSER.key -out $KUSER.csr -subj "/CN=$KUSER"
  # sign csr with CA
  openssl x509 -req -in $KUSER.csr \
	-CA $CA_DIR/ca.crt \
	-CAkey $CA_DIR/ca.key \
	-CAcreateserial \
	-out $KUSER.crt \
	-days 500
done

for KUSER in deploy_view deploy_edit; do
  kubectl config set-credentials $KUSER \
	  --client-certificate=$KUSER.crt \
	  --client-key=$KUSER.key
done

for KUSER in deploy_view deploy_edit; do
  kubectl config set-context $KUSER \
	  --cluster=minikube \
	  --user=$KUSER
done
