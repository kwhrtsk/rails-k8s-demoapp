SHELL = /bin/bash

ifeq ($(TAG),)
	tag := 0.0.1
else
	tag := $(TAG)
endif

.PHONY: *

minikube-start:
	minikube start --cpus=3 --memory=2048 --vm-driver=hyperkit --disk-size=12g
	minikube addons enable ingress

minikube-delete:
	minikube delete

minikube-dashboard:
	minikube dashboard

docker-build:
	docker build ../../ -t demoapp:$(tag)
