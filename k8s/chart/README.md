Helm Chart
==========

Sample helm chart based on [step4 manifests](../manifests-step4/).

# Requirements

* helm
```
brew install kubernetes-helm
```

# Getting started with minikube

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

# setup helm's server module a.k.a Tiller
helm init --wait

# install all objects by helm chart and wait until the deployment complete
helm upgrade staging . --install --wait --set ingress.host=${COMMON_NAME}

# open demoapp in browser
open https://demoapp-puma.$(minikube ip).nip.io/

# cleanup all objects
helm delete staging --purge

# uninstall Tiller
helm reset
```

See also [Makefile](Makefile). There are shorthand tasks for the above operations.

```
make kubectl-create-secret-tls
make helm-upgrade
make open
make helm-delete
make helm-reset
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
# and wait until the canary-deployment is completed
helm upgrade staging . --install --wait \
  --set ingress.host=${COMMON_NAME} \
  --set rails.image.canaryTag=0.0.2

# Update all other puma deployments that will not execute rails db:migrate
# and wait until the deployment is completed
kubectl set image deploy/demoapp-puma puma=demoapp:0.0.2
helm upgrade staging . --install --wait \
  --set ingress.host=${COMMON_NAME} \
  --set rails.image.canaryTag=0.0.2 \
  --set rails.image.tag=0.0.2
```

See also [Makefile](Makefile). There are shorthand tasks for the above operations.

```
make TAG=0.0.2 minikube-docker-build
make TAG=0.0.2 canary-deploy
make TAG=0.0.2 deploy
```

To reduce `--set` parameter, update your values.yaml.
