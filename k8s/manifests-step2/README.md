k8s step1
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

# open demoapp in browser
minikube service demoapp-puma

# cleanup all objects
cat *.yaml | kubectl delete -f -
```

# Restrictions

* Data of MySQL and Redis is volatile. To persistent this, refer to step3.
* Application URL will change each kubectl apply. To fix this, refer to step3.
