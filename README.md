<h1>Psykube&nbsp;&nbsp;<img height="50px" src="https://raw.githubusercontent.com/CommercialTribe/psykube/master/psykube-duck.png"/>&nbsp;&nbsp;a faster way to deploy to Kubernetes!</h1>
[![Build Status](https://travis-ci.org/CommercialTribe/psykube.svg?branch=master)](https://travis-ci.org/CommercialTribe/psykube)

[What is Psykube?](#what-is-psykube) |
[Installation](#installation) |
[The Psykube YAML](#the-psykube-yaml) |
[Getting Started](#getting-started) |
[Commands](#commands) |
[Contributing](./CONTRIBUTING.md)

# What is Psykube?
Kubernetes is a powerful system, but it comes with its own learning curve. To deploy a single application you have to come familiar with a set of concepts. For example a single hello world application may be comprised of a `Deployment`, `Service`, and `Ingress` manifest file. Psykube aims to make that simpler by unifying your applications configuration into a single file.

For the above example you may expect something like this in the `.psykube.yml` file and compare to what you would need to write in raw kubernets manifests to do the same thing:

###### psykube.yml
```yaml
name: hello-world
registry_user: johndoe
ports:
  http: 8080
  ingress:
  tls: true
  host: hello-world.example.com
```

###### kubernetes manifests
```yaml
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
name: hello-world
namespace: default
labels:
  psykube: 'true'
annotations:
  psykube.io/whodunit: jwaldrip
  psykube.io/cause: psykube generate default
  psykube.io/last-applied-at: '2017-03-01T15:54:28+0000'  
spec:
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-world
        image: johndoe/hello-world:sha256-5ddfe4537dea1b49b7157f982620331fc770852cea7161c0350dfd9cc30a1024
        ports:
        - name: http
          containerPort: 8080
        env:
        - name: HTTP_PORT
          value: '8080'
        - name: PORT
          value: '8080'
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  progressDeadlineSeconds: 300
---
apiVersion: v1
kind: Service
metadata:
  name: hello-world
  namespace: default
  labels:
    psykube: 'true'
    service: hello-world
spec:
  ports:
  - name: http
    protocol: TCP
    port: 8080
  selector:
    app: hello-world
  type: ClusterIP
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: hello-world
  namespace: default
  labels:
    psykube: 'true'
  annotations:
    psykube.io/whodunit: jwaldrip
    psykube.io/cause: psykube generate default
    psykube.io/last-applied-at: '2017-03-01T15:54:28+0000'
    kubernetes.io/tls-acme: 'true'
spec:
  tls:
  - hosts:
    - hello-world.example.com
    secretName: cert-1f94807c01b19a7a468c795e21a55cd55db51bde
  rules:
  - host: hello-world.example.com
    http:
      paths:
      - path: "/"
        backend:
          serviceName: hello-world
          servicePort: 8080
```

## Installation

### Using Homebrew for OSX
You can install `psykube` on OSX using homebrew by running:

```sh
brew install commercialtribe/tools/psykube
```

### Binaries
You can also download the [pre-built binaries](https://github.com/CommercialTribe/psykube/releases/latest).

## The Psykube YAML

A .psykube.yml is required in the root for each app. This can be overridden with
the `-f` or `--file` flag on any command.

### Template Variables
The .psykube.yml allows for expanding variables using the `<<var.name>>` template syntax. The
following variables are available within the template:

| Var | Description
|---|---
| `metadata.namespace` | The namespace provided with the `--namespace` flag on the command.
| `metadata.cluster_name` | The name of the cluster.
| `metadata.name` | The name of the application.
| `env.{name}` | An environment variable referenced by name.
| `git.branch` | The current git branch.
| `git.tag` | The current git tag.
| `git.sha` | The current git sha.

#### Example Variable Usage

```yaml
ingress:
  host: {{metadata.namespace}}.k8s.example.com
```

### Reference
You can find a detailed example of the `.psykube.yml` in [reference/.psykube.yml](./reference/.psykube.yml)
More examples can be found in the example dir.

**NOTE:** There is also an example .travis.yml file with an example of how to deploy to google container engine.

## Getting Started

To get started with psykube you can run the [`psykube init`](#psykube-init) command

## Commands

### `psykube-init`
Generates a .psykube.yml in the current directory.

#### Usage:
  `psykube init [flags...] [arg...]`

#### Flags:

| long              | short | default                              | description
| ----------------- | ----- | ------------------------------------ | --------------------------------------
| `--env`           | `-e`  |                                      | Set an environment variable.
| `--file`          | `-f`  | `./.psykube.yml`                     | The location of the psykube manfest yml file.
| `--help`          |       |                                      | Displays help for the current command.
| `--host`          | `-h`  |                                      | Set a host.
| `--image`         | `-i`  |                                      | Set the image, this takes precedence over `--registry-host` and `--registry-user`.
| `--name`          | `-N`  | current directory name               | Set the name of the application used for deployment.
| `--namespace`     | `-n`  |                                      | Set the namespace.
| `--overwrite`     | `-o`  | `false`                              | Overwrite the file if it exists.
| `--port`          | `-p`  |                                      | Set a port. (can be in the format of `--port 1234` or `--port http=1234`).
| `--registry-host` | `-R`  |                                      | |
| `--registry-user` | `-U`  | current docker user                  | |
| `--tls`           | `-t`  | `false`                              | Enable tls in the ingress container.
