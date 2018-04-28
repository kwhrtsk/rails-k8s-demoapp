SHELL = /bin/bash

all:
	$(MAKE) minikube-docker-build
	$(MAKE) kubectl-apply
	$(MAKE) kubectl-rollout-status
	$(MAKE) minikube-service

clean: kubectl-delete

minikube-docker-build:
	eval $$(minikube docker-env) && docker build ../../ -t demoapp:0.0.1

kubectl-apply:
	cat *.yaml | kubectl apply -f -

kubectl-rollout-status:
	kubectl rollout status deploy demoapp-puma

minikube-service:
	minikube service demoapp-puma

kubectl-delete:
	cat *.yaml | kubectl delete -f -

stern:
	stern demoapp*
