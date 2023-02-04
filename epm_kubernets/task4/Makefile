CUR_DIR := $(shell pwd)
USER := k8s_user
CRT := $(CUR_DIR)/$(USER).crt
KEY := $(CUR_DIR)/$(USER).key
CSR := $(CUR_DIR)/$(USER).csr

CA_DIR := $(HOME)/.minikube

credentials:
	@echo "Generate private key"
	@openssl genrsa -out $(KEY) 2048
	@echo "Create a certificate signing request"
	@openssl req -new -key $(KEY) -out $(CSR) -subj "/CN=$(USER)"
	@echo "Sign the CSR in the Kubernetes CA. In out case minikube certificates are located at ~/.minikube"
	@openssl x509 -req -in $(CSR) \
		-CA $(CA_DIR)/ca.crt \
		-CAkey $(CA_DIR)/ca.key \
		-CAcreateserial \
		-out $(CRT) \
		-days 500

user:
	if ! test -f $(CRT); then false; fi
	if ! test -f $(KEY); then false; fi
	@echo "Create user in kubernetes"
	@kubectl config set-credentials $(USER) --client-certificate=$(CRT) --client-key=$(KEY)
	@echo "Set context for user"
	@kubectl config set-context $(USER) --cluster=minikube --user=$(USER)
	@touch $@
