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

# open demoapp in browser
minikube service demoapp-puma

# cleanup all objects
cat *.yaml | kubectl delete -f -
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

# Restrictions

* Application URL will change each kubectl apply. To fix this, refer to step4.
