SHELL = /bin/bash

export MINIKUBE_IP := $(shell minikube ip)
export COMMON_NAME := demoapp-puma.$(MINIKUBE_IP).nip.io

.PHONY: kubectl-*

kubectl-apply: kubectl-create-secret-tls
	cat *.yaml | envsubst '$$MINIKUBE_IP' | kubectl apply -f -

kubectl-delete:
	cat *.yaml | kubectl delete -f - --ignore-not-found
	kubectl delete secret demoapp-puma-tls

server.pem:
	openssl req -new -x509 -nodes -keyout server.key -days 3650 \
		-subj "/CN=${COMMON_NAME}" \
		-extensions v3_req \
		-config <(cat openssl.conf | envsubst '$$COMMON_NAME') > server.pem
	openssl x509 -text < server.pem

kubectl-create-secret-tls: server.pem
	kubectl delete secret demoapp-puma-tls --ignore-not-found
	kubectl create secret tls demoapp-puma-tls --key server.key --cert server.pem

stern:
	stern demoapp*

minikube-service:
	minikube service demoapp-puma

open:
	open http://$(COMMON_NAME)
	open https://$(COMMON_NAME)
