k8s step2
=========

Sample manifest using these API objects:

* Deployment
* Service
* ConfigMap
* Secret
* Job `<- New!`

# Usage

```
# setup all objects
cat *.yaml | kubectl apply -f -

# open demoapp in browser
minikube service demoapp-puma

# cleanup all objects
cat *.yaml | kubectl delete -f -
```

See also [Makefile](Makefile). There are shorthand tasks for the above operations.

```
make kubectl-apply
make minikube-service
make kubectl-delete
```

## Migration

To execute `rake db:migrate`, run the following command:

```
# Create new migration for example
./bin/rails g migration AddLiksToMessage likes:integer
./bin/rails db:migrate

# Build new image as demoapp:0.0.2
cd k8s/minikube
docker-build 0.0.2

# Only update canary-release deployment that will execute rails db:migrate
kubectl set image deploy/demoapp-puma-canary puma=demoapp:0.0.2

# Update all other puma deployments that will not execute rails db:migrate
kubectl set image deploy/demoapp-puma puma=demoapp:0.0.2
```

# Restrictions

* Data of MySQL and Redis is volatile. To persistent this, refer to step3.
* Application URL will change each kubectl apply. To fix this, refer to step4.
