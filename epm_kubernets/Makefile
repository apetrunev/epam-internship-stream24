KUBECTL_VERSION := v1.23.5
KUBECTL_LINK := https://storage.googleapis.com/kubernetes-release/release/$(KUBECTL_VERSION)/bin/linux/amd64/kubectl
KUBECTL_BIN := $(shell basename $(KUBECTL_LINK))
TMP_KUBECTL := /tmp/kubectl-dir

MINIKUBE_DOCKERMACHINE_DRIVER_LINK := https://github.com/kubernetes/minikube/releases/download/v1.23.2/docker-machine-driver-kvm2_1.23.2-0_amd64.deb
MINIKUBE_LINK := https://github.com/kubernetes/minikube/releases/download/v1.23.2/minikube_1.23.2-0_amd64.deb
TMP_MINIKUBE := /tmp/minikube-dir

kubectl:
	@mkdir -vp $(TMP_KUBECTL)
	@cd $(TMP_KUBECTL)/ && curl -LO $(KUBECTL_LINK)
	@chmod -v +x $(TMP_KUBECTL)/$(KUBECTL_BIN)
	@sudo cp -v $(TMP_KUBECTL)/$(KUBECTL_BIN) /usr/local/bin/

.ONESHELL:
minikube:
	mkdir -vp $(TMP_MINIKUBE)
	cd $(TMP_MINIKUBE)/
	curl -LO $(MINIKUBE_LINK)
	curl -LO $(MINIKUBE_DOCKERMACHINE_DRIVER_LINK)
	sudo find ./ -mindepth 1 -maxdepth 1 -type f -name "*.deb" -exec apt-get -y install "{}" \;
	
