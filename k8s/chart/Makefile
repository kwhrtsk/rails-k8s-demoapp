SHELL = /bin/bash

export MINIKUBE_IP := $(shell minikube ip)
export COMMON_NAME := demoapp-puma.$(MINIKUBE_IP).nip.io

ifeq ($(TAG),)
	tag := 0.0.1
else
	tag := $(TAG)
endif

ifeq ($(RELEASE),)
	release := staging
else
	release := $(RELEASE)
endif

all:
	$(MAKE) helm-init
	$(MAKE) minikube-docker-build
	$(MAKE) kubectl-create-secret-tls
	$(MAKE) helm-upgrade
	$(MAKE) open

clean:
	rm -f server.pem server.key
	$(MAKE) helm-delete
	$(MAKE) helm-reset

update: 
	$(MAKE) TAG=$(tag) minikube-docker-build
	$(MAKE) TAG=$(tag) deploy

minikube-docker-build:
	eval $$(minikube docker-env) && \
		if [ "$$(docker image ls -q demoapp:$(tag))" == "" ]; then \
			docker build ../../ -t demoapp:$(tag); \
		fi

helm-init:
	helm init --wait

helm-reset:
	helm reset

helm-upgrade:
	helm upgrade $(release) . --install --wait --set ingress.host=$(COMMON_NAME)

helm-delete:
	helm delete $(release) --purge
	kubectl delete secret demoapp-puma-tls

deploy:
	helm upgrade $(release) . --install --wait --set ingress.host=$(COMMON_NAME) --set rails.image.tag=$(TAG)

server.pem:
	openssl req -new -x509 -nodes -keyout server.key -days 3650 \
		-subj "/CN=${COMMON_NAME}" \
		-extensions v3_req \
		-config <(cat openssl.conf | sed s/\$${COMMON_NAME}/$(COMMON_NAME)/) > server.pem
	openssl x509 -text < server.pem

kubectl-create-secret-tls: server.pem
	kubectl delete secret demoapp-puma-tls --ignore-not-found
	kubectl create secret tls demoapp-puma-tls --key server.key --cert server.pem

open:
	open https://$(COMMON_NAME)

stern:
	stern $(release)-demoapp.*
