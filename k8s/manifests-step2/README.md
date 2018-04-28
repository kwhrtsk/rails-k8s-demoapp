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

# wait until the deployment is completed
kubectl rollout status deploy demoapp-puma

# open demoapp in browser
minikube service demoapp-puma

# cleanup all objects
cat *.yaml | kubectl delete -f -
```

See also [Makefile](Makefile). There are shorthand tasks for the above operations.

```
make kubectl-apply
make kubectl-rollout-status
make minikube-service
make kubectl-delete
```

## Migration

For example, when you create new migration like this:

```
# Move to RAILS_ROOT
cd ../../

# Create new migration for example
./bin/rails g migration AddLiksToMessage likes:integer
./bin/rails db:migrate
```

To execute `rake db:migrate` on k8s, run the following commands:

```
# Move to RAILS_ROOT
cd ../../

# Build new image as demoapp:0.0.2
eval $(minikube docker-env) && docker build . -t demoapp:0.0.2

# Only update canary-release deployment that will execute rails db:migrate
kubectl set image deploy/demoapp-puma-canary puma=demoapp:0.0.2

# wait until the canary-deployment is completed
kubectl rollout status deploy demoapp-puma-canary

# Update all other puma deployments that will not execute rails db:migrate
kubectl set image deploy/demoapp-puma puma=demoapp:0.0.2

# wait until the deployment is completed
kubectl rollout status deploy demoapp-puma
```

See also [Makefile](Makefile). There are shorthand tasks for the above operations.

```
make TAG=0.0.2 minikube-docker-build
make TAG=0.0.2 canary-deploy
make TAG=0.0.2 deploy
```

# Restrictions

* Data of MySQL and Redis is volatile. To persistent this, refer to step3.
* Application URL will change each kubectl apply. To fix this, refer to step4.
