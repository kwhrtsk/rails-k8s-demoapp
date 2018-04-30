k8s step3
=========

Sample manifest using these API objects:

* Deployment
* Service
* ConfigMap
* Secret
* Job
* PersistentVolumeClaim `<- New!`

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

## Deploy new rails image includes migration

For example, when you create new migration like this:

```
# Move to RAILS_ROOT
cd ../../

# Create new migration for example
./bin/rails g migration AddLiksToMessage likes:integer
./bin/rails db:migrate
```

To build new rails image, deploy, and execute `rake db:migrate` on k8s, run the following commands:

```
# Move to RAILS_ROOT
cd ../../

# Build new image as demoapp:0.0.2
eval $(minikube docker-env) && docker build . -t demoapp:0.0.2

# Update all puma deployments. Only one of them will execute rails db:migrate.
kubectl set image deploy/demoapp-puma puma=demoapp:0.0.2

# wait until the deployment is completed
kubectl rollout status deploy demoapp-puma
```

Rails's migration is exclusive controlled by RDBMS's lock system at least when executed on MySQL or PostgreSQL.
So to execute `rails db:migrate` safely, all you need is just ignore `ActiveRecord::ConcurrentMigrationError`.
Please refer to [bin/start-puma](/bin/start-puma) and [db:try_migrate](/lib/tasks/db.rake) for details.

See also [Makefile](Makefile). There are shorthand tasks for the above operations.

```
make TAG=0.0.2 minikube-docker-build
make TAG=0.0.2 deploy
```

# Restrictions

* Application URL will change each kubectl apply. To fix this, refer to step4.
