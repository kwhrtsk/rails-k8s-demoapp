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
kubectl apply -f migrations/migrate-db-job-0.0.2.yaml
```

`0.0.2` means image tag.
Create new manifest file when new migration has been created.
Because `Job` object is immutable, so you cannot update manifest that alrady applied: `kubectl apply` will be failed.
Also `kubectl patch` will be failed.
