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

$ open http://localhost:3000/
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
