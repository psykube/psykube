<h1><img height="30px" src="https://raw.githubusercontent.com/CommercialTribe/psykube/master/psykube-duck.png"/>&nbsp;&nbsp;Psykube : A faster way to deploy to Kubernetes!</h1>
[![Build Status](https://travis-ci.org/CommercialTribe/psykube.svg?branch=master)](https://travis-ci.org/CommercialTribe/psykube)

# What is Psykube?
Kubernetes is a powerful system, but it comes with its own learning curve. To deploy a single application you have to come familiar with a set of concepts. For example a single hello world application may be comprised of a `Deployment`, `Service`, and `Ingress` manifest file. Psykube aims to make that simpler by unifying your applications configuration into a single file. 

For the above example you may expect something like this:

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

###### Kubernetes Equivelent
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

## Homebrew for OSX
You can install `psykube` on OSX using homebrew by running:

```sh
brew install commercialtribe/tools/psykube
```

## Binaries
You can also download the [pre-built binaries](https://github.com/CommercialTribe/psykube/releases).

# Usage
`psykube [command] [arguments]`

# Commands

## `apply <cluster>`
Applies the generated kubernetes manifests for the specified cluster.

## `copy-namespace <from> <to>`
Copies a kubernetes namespace and (most) of its resources to a new namespace.

## `copy-resource <resource_type> <resource_name> <new_resource_name>`
Copies a resource.

## `delete <cluster>`
Deletes all associated kubernetes manifests for the current app.

## `exec <command>`
Finds a running pod belonging to this app and executes a command within it.

## `logs <command>`
Lists the logs for the current application.

## `generate <cluster>`
Generates and outputs the kubernetes manifests for the specified cluster.

## `help <command>`
Lists help for any command.

## `port-forward <local> <remote>`
Finds a running pod belonging to this app and forwards the specified remote port to the specified local port.

## `push`
Builds and pushes the docker image to the registry.    

## `status <cluster>`
Lists the status of the pods running for the current app and for the specified cluster.

## `history <cluster>`
Get deployment history.

## `rollback <cluster>`
Rollback to a previous deployment.

## `version`
Prints the psykube version.

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

#### Example

```yaml
ingress:
  host: {{metadata.namespace}}.k8s.example.com
```

### .psykube.yml Reference
You can find a detailed example of the `.psykube.yml` in [reference/.psykube.yml](./reference/.psykube.yml)
More examples can be found in the example dir.

**NOTE:** There is also an example .travis.yml file with an example of how to deploy to google container engine.
