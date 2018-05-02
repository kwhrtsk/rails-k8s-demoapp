SHELL = /bin/bash

all:
	$(MAKE) kubectl-apply
	$(MAKE) kubectl-rollout-status
	$(MAKE) kubectl-port-forward

clean: kubectl-delete

kubectl-apply:
	cat *.yaml | kubectl apply -f -

kubectl-rollout-status:
	kubectl rollout status deploy mysql

kubectl-port-forward:
	kubectl port-forward deployment/mysql 3306

kubectl-delete:
	cat *.yaml | kubectl delete -f -

stern:
	stern mysql*
