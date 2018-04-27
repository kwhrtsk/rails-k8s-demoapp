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
export MINIKUBE_IP=$(minikube ip)
export COMMON_NAME=demoapp-puma.${MINIKUBE_IP}.nip.io
openssl req -new -x509 -nodes -keyout server.key -days 3650 \
  -subj "/CN=${COMMON_NAME}" \
  -extensions v3_req \
  -config <(cat openssl.conf | envsubst '$COMMON_NAME') > server.pem
kubectl create secret tls demoapp-puma-tls --key server.key --cert server.pem

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

See also [Makefile](Makefile). There are shorthand tasks for the above operations.

```
make kubectl-create-secret-tls
make kubectl-apply
make open
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
