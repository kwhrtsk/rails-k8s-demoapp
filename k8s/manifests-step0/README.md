k8s step0
=========

Training for `kubectl` and k8s's manifest file.

Just run `mysql` container on k8s cluster.

# Usage

```
# setup mysql deployment
kubectl apply -f mysql-deploy.yaml

# wait until the deployment is completed
kubectl rollout status deploy mysql

# port-forward mysql's port to local 3306
kubectl port-forward deployment/mysql 3306
```

```
# In another terminal, connect to mysql server
$ mysql -u root --host 0.0.0.0 --port 3306
```

See also [Makefile](Makefile). There are shorthand tasks for the above operations.

```
make kubectl-apply
make kubectl-rollout-status
make kubectl-port-forward
```
