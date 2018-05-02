SHELL = /bin/bash

export MINIKUBE_IP := $(shell minikube ip)
export COMMON_NAME := demoapp-puma.$(MINIKUBE_IP).nip.io

ifeq ($(TAG),)
	tag := 0.0.1
else
	tag := $(TAG)
endif

all:
	$(MAKE) minikube-docker-build
	$(MAKE) kubectl-apply
	$(MAKE) kubectl-rollout-status
	$(MAKE) open

clean: kubectl-delete
	rm -f server.pem server.key

update: 
	$(MAKE) TAG=$(tag) minikube-docker-build
	$(MAKE) TAG=$(tag) deploy

minikube-docker-build:
	eval $$(minikube docker-env) && \
		if [ "$$(docker image ls -q demoapp:$(tag))" == "" ]; then \
			docker build ../../ -t demoapp:$(tag); \
		fi

kubectl-apply: kubectl-create-secret-tls
	cat *.yaml | envsubst '$$MINIKUBE_IP' | kubectl apply -f -

kubectl-rollout-status:
	kubectl rollout status deploy demoapp-puma

minikube-service:
	minikube service demoapp-puma

kubectl-delete:
	cat *.yaml | kubectl delete -f - --ignore-not-found
	kubectl delete secret demoapp-puma-tls --ignore-not-found

deploy:
	kubectl set image deploy/demoapp-puma puma=demoapp:$(tag)
	kubectl rollout status deploy demoapp-puma

server.pem:
	openssl req -new -x509 -nodes -keyout server.key -days 3650 \
		-subj "/CN=${COMMON_NAME}" \
		-extensions v3_req \
		-config <(cat openssl.conf | envsubst '$$COMMON_NAME') > server.pem
	openssl x509 -text < server.pem

kubectl-create-secret-tls: server.pem
	kubectl delete secret demoapp-puma-tls --ignore-not-found
	kubectl create secret tls demoapp-puma-tls --key server.key --cert server.pem

open:
	open https://$(COMMON_NAME)

stern:
	stern demoapp*
