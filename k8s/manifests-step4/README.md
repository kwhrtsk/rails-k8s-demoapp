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
$ brew install gettext
$ brew link --force gettext
```

# Usage

```
# setup secret for TLS certificates
# this commands will generate self signed server certificate and key: server.pem, server.key
# key and cert are stored in Secret object named `demoapp-puma-tls`.
# you can confirm this object by `kubectl describe secret demoapp-puma-tls`
./kubectl-create-secret-tls

# setup all objects
cat *.yaml | kubectl apply -f -

# open demoapp in browser
# http
open http://demoapp-puma.$(minikube ip).nip.io/
# https
open https://demoapp-puma.$(minikube ip).nip.io/

# cleanup all objects
cat *.yaml | kubectl delete -f -
kubectl delete secret demoapp-puma-tls
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
