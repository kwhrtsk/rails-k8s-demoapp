k8s step1
=========

Sample manifest using these API objects:

* Deployment
* Service
* ConfigMap
* Secret

# Usage

```
# setup all objects
cat *.yaml | kubectl apply -f -

# open demoapp in browser
minikube service demoapp-puma

# cleanup all objects
cat *.yaml | kubectl delete -f -
```

# Restrictions

* `puma` deployment has Only 1 replicas to avoid conflicts `rake db:setup` from multiple puma containers from `./bin/setup-and-start-puma`.
  To increase replica, refer to step2.
* Data of MySQL and Redis is volatile. To persistent this, refer to step3.
* Application URL will change each kubectl apply. To fix this, refer to step4.
