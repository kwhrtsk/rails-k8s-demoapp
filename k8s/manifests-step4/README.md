k8s step4
=========

Sample manifest using these API objects:

* Deployment
* Service
* ConfigMap
* Secret
* Job
* PersistentVolumeClaim
* Ingress `<- New!`

# Requirements

* envsubst
```
brew install gettext
brew link --force gettext
```

# Usage

```
# setup secret for TLS certificates
# this commands will generate self signed server certificate and key: server.pem, server.key
# key and cert are stored in Secret object named `demoapp-puma-tls`.
# you can confirm this object by `kubectl describe secret demoapp-puma-tls`
export MINIKUBE_IP=$(minikube ip)
export COMMON_NAME=demoapp-puma.${MINIKUBE_IP}.nip.io
openssl req -new -x509 -nodes -keyout server.key -days 3650 \
  -subj "/CN=${COMMON_NAME}" \
  -extensions v3_req \
  -config <(cat openssl.conf | envsubst '$COMMON_NAME') > server.pem
kubectl create secret tls demoapp-puma-tls --key server.key --cert server.pem

# setup all objects
cat *.yaml | envsubst '$MINIKUBE_IP' | kubectl apply -f -

# wait until the deployment is completed
kubectl rollout status deploy demoapp-puma

# open demoapp in browser
open https://demoapp-puma.$(minikube ip).nip.io/

# cleanup all objects
cat *.yaml | kubectl delete -f -
kubectl delete secret demoapp-puma-tls
```

See also [Makefile](Makefile). There are shorthand tasks for the above operations.

```
make kubectl-create-secret-tls
make kubectl-apply
make kubectl-rollout-status
make open
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

