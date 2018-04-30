SHELL = /bin/bash

ifeq ($(TAG),)
	tag := 0.0.1
else
	tag := $(TAG)
endif

all:
	$(MAKE) minikube-docker-build
	$(MAKE) kubectl-apply
	$(MAKE) kubectl-rollout-status
	$(MAKE) minikube-service

clean: kubectl-delete

update: 
	$(MAKE) TAG=$(tag) minikube-docker-build
	$(MAKE) TAG=$(tag) deploy

minikube-docker-build:
	eval $$(minikube docker-env) && \
		if [ "$$(docker image ls -q demoapp:$(tag))" == "" ]; then \
			docker build ../../ -t demoapp:$(tag); \
		fi

kubectl-apply:
	cat *.yaml | kubectl apply -f -

kubectl-rollout-status:
	kubectl rollout status deploy demoapp-puma

minikube-service:
	minikube service demoapp-puma

kubectl-delete:
	cat *.yaml | kubectl delete -f -

deploy:
	kubectl set image deploy/demoapp-puma puma=demoapp:$(tag)
	kubectl rollout status deploy demoapp-puma

stern:
	stern demoapp*
