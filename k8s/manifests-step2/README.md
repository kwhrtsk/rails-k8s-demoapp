k8s step1
=========

Sample manifest using these API objects: Deployment, Service, ConfigMap, Secret.

# Usage

```
# setup all objects
cat *.yaml | kubectl apply -f -

# cleanup all objects
cat *.yaml | kubectl delete -f -
```

# Restrictions

* Data of MySQL and Redis is volatile. To persistent this, refer to step2.
* Application URL will change each kubectl apply. To fix this, refer to step2.
* `puma` deployment has Only 1 replicas to avoid conflicts `rake db:setup` from multiple puma containers from `./bin/setup-and-start-puma`.
