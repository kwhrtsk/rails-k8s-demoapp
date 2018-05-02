Demo for Docker/Kubernetes with Rails
=====================================

**WIP**

Minimal sample application to demonstrate Rails application development with Docker and Kubernetes.

# Start preview mode with Docker Compose

Prerequisites

* Docker, Docker Compose

```
$ git clone https://github.com/kwhrtsk/rails-k8s-demoapp.git
$ cd rails-k8s-demoapp

# Start mysql and redis container, and build rails app image and start.
$ docker-compose -f docker-compose-preview.yml up -d

# Open top page in your browser
$ open http://localhost:3000/

# Stop all containers and cleanup volumes
$ docker-compose -f docker-compose-preview.yml down
```

# Start local server processes with MySQL and Redis on Docker Compose

Prerequisites

* Docker, Docker Compose
* Ruby 2.5.1
* Node.js 6.0.0+
* Yarn 0.25.2+
* foreman

```
$ git clone https://github.com/kwhrtsk/rails-k8s-demoapp.git
$ cd rails-k8s-demoapp

# Start mysql and redis container
$ docker-compose up -d

# Install rubygems
$ bundle install
$ gem install foreman

# Start puma, sidekiq and webpack-dev-server
$ foreman start -f Procfile
```

```
# In another terminal, open top page in your browser.
$ open http://localhost:3000/
```

# Kubernetes

Tested with:

| Name         | Version                |
| ------------ | ---------------------- |
| minikube     | 0.26.1 (k8s 1.10.0)    |
| kubectl      | 1.10.1                 |
| helm         | 2.8.2                  |
| hyperkit     | v0.20171204-60-g0e5b6b |
| stern        | 1.6.0                  |

## Deploy on Kubernetes cluster with plain YAML manifest files

Example manifests to deploy to minikube instance.

* [step1](k8s/manifests-step1/)
  * Use only these API Object: `Deployment`, `Service`, `ConfigMap`, `Secret`
* [step2](k8s/manifests-step2/)
  * Add `Job` from step1's constitution to execute `rails db:setup`.
  * Supports multiple puma containers.
* [step3](k8s/manifests-step3/)
  * Add `PersistentVolumeClaim` from step2's constitution to persistent data of mysql and redis.
* [step4](k8s/manifests-step4/)
  * Add `Ingress` from step3's constitution to expose application with custom TLS certificate and fixed URL.

## Helm Chart and operation examples

[Helm Chart](k8s/chart/) example and operation scripts for setup, deploy, and rolling update rails containers.
This chart based on [manifests-step4](k8s/manifests-step4/).
