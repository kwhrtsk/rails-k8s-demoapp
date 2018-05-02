SHELL = /bin/bash

ifeq ($(TAG),)
	tag := 0.0.1
else
	tag := $(TAG)
endif

ifeq ($(VM_DRIVER),)
	vm_driver := hyperkit
else
	vm_driver := $(VM_DRIVER)
endif

.PHONY: *

all: minikube-start

clean: minikube-delete

minikube-start:
	minikube start --cpus=3 --memory=2048 --vm-driver=$(vm_driver) --disk-size=12g
	minikube addons enable ingress

minikube-delete:
	minikube delete

minikube-dashboard:
	minikube dashboard

docker-build:
	docker build ../../ -t demoapp:$(tag)
