<h1>Psykube&nbsp;&nbsp;<img height="50px" src="https://raw.githubusercontent.com/CommercialTribe/psykube/master/psykube-duck.png"/>&nbsp;&nbsp;a faster way to deploy to Kubernetes!&nbsp;&nbsp;<a href="https://travis-ci.org/CommercialTribe/psykube"><img src="https://travis-ci.org/CommercialTribe/psykube.svg?branch=master" /></a></h1>
[What is Psykube?](#what-is-psykube)
| [Installation](#installation)
| [The Psykube YAML](#the-psykube-yaml)
| [Cluster Assumptions](#cluster-assumptions)
| [Getting Started](#getting-started)
| [Playground](#playground)
| [Commands](#commands)

# What is Psykube?
Kubernetes is a powerful system, but it comes with its own learning curve. To deploy a single application you have to come familiar with a set of concepts. For example a single hello world application may be comprised of a `Deployment`, `Service`, and `Ingress` manifest file. Psykube aims to make that simpler by unifying your applications configuration into a single file.

For the above example you may expect something like this in the `.psykube.yml` file.

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

## Installation

### Pre-requirements
* `kubectl` installed on your system.
* `docker` installed on your system.
* `git` installed on your system.

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
The .psykube.yml allows for expanding variables using the `{{var.name}}` template syntax. The
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

## Cluster Assumptions

Psykube works best with a certain kubernetes setup.

1. A cluster running that latest kubernetes. _(**NOTE:** psykube versions line up with kubernetes versions)_
1. [An ingress controller](https://kubernetes.io/docs/user-guide/ingress/#ingress-controllers).
1. [kube-lego](https://github.com/jetstack/kube-lego) controller installed for automatic TLS.

## Getting Started

> **Before you start...**  
  *We make reference to Kubernetes documentation in this README, this is only for reference, Psykube's main purpose is to abstract away the complexity of writing and maintaining the file manifests needed to deploy applications to Kubernetes. As you start learning about the Kubernetes objects we reference you can be rest assured that psykube will be generating all these files for you. (you can see how .psykube.yml files translate by checking our the [playground](#playground))*

### Generating the .psykube.yml file

To get started with psykube you can run the [`psykube init`](#psykube-init) command. You can then edit the `.psykube.yml` file generated in the current directory.

```yaml
name: hello-world
registry_user: johndoe
```

> If an application (without exposing it as a service) is all you need, you can stop here and go straight to [deploying-an-application](#deploying-an-application), or continue for more detail.

### Exposing an application as a service
While it's great to have an application deployed to Kubernetes, you cannot actually interact with it unless it exposes a [Kubernetes Service](https://kubernetes.io/docs/user-guide/services/). In order to do this all we have to do is assign ports, the port you specify will become both the container port and the service port. Once you add a port your `.psykube.yml` should now look like this:

```yaml
name: hello-world
registry_user: johndoe
ports:
  http: 8080
```

#### More advanced service customization.
You also have the option of doing more advance service customization by using the `service` object. For example, you may want to change the type of the service to be a `LoadBalancer` or `Headless` service rather than the default `ClusterIP`. For example, if you wanted to make the service a `LoadBalancer`, which exposes it with an external IP, you would do the following.

```yaml
name: hello-world
registry_user: johndoe
service:
  type: LoadBalancer
ports:
  http: 8080
```

> If an application and service is all you need, you can stop here and go straight to [deploying-an-application](#deploying-an-application), or continue for more detail.

### Allocating an application's ingress records
Sometimes you want more than an internal service, and you may not want to just expose your service as a `LoadBalancer`. This is where ingress comes into play. If your cluster has an ingress controller, then it will make use of the [Kubernetes Ingress](https://kubernetes.io/docs/user-guide/ingress/) records generated by the global and cluster `ingress` objects. Ingress, requires for the application to have an [exposed service](#exposing-an-application-as-a-service). The simplest ingress may just include a single hostname:

```yaml
name: hello-world
registry_user: johndoe
service:
  type: LoadBalancer
ports:
  http: 8080
ingress:
  host: my-app.com
```

#### Ingress TLS
In addition to a hostname you may want to add TLS/HTTPS to your ingress. By setting `tls: true` in your ingress object, psykube will auto-generate a secret_name for your certificate and add an annotation to allow for [kube-lego](https://github.com/jetstack/kube-lego) to generate a free SSL certificate using [Let's Encrypt](https://letsencrypt.org/).

#### Advanced ingress rules
If the ingress of your application requires more customization you can use the `hosts` and `tls` objects:

```yaml
name: hello-world
registry_user: johndoe
service:
  type: LoadBalancer
ports:
  http: 8080
ingress:
  tls:
    secret_name: my-app-cert
  hosts:
    my-app.com:
      path: /
```

### Deploying an application

Once you have generated the `.psykube.yml` you should be able to immediately be able to deploy using the [`psykube apply <cluster_name>`](#psykube-apply) command. Invoking the command will build your docker container, push it up to the specified registry, generate the kubernetes manifests and apply them to the proper Kubernetes environment.

## Playground
Psykube's main purpose is to abstract away much of the complexity involved in deploying and managing an application on Kubernetes. A primary component to this is how the `.psykube.yml` file translates into the files we generate for kubernetes. You can boot up the playground using the [`psykube playground`](#psykube-playground) command or by visiting [psykube.commercialtribe.ninja](https://psykube.commercialtribe.ninja/#bmFtZTogcHN5a3ViZQp0eXBlOiBEZXBsb3ltZW50CnJlZ2lzdHJ5X2hvc3Q6IGdjci5pbwpyZWdpc3RyeV91c2VyOiBjb21tZXJjaWFsLXRyaWJlCgphcmdzOiBbICJwbGF5Z3JvdW5kIiwgIi0tYmluZD0wLjAuMC4wIiBdCnBvcnRzOgogIGh0dHA6IDgwODAKaW5ncmVzczoKICB0bHM6IHRydWUKICBob3N0OiBwc3lrdWJlLmNvbW1lcmNpYWx0cmliZS5uaW5qYQoKY2x1c3RlcnM6CiAgZGVmYXVsdDoKICAgIGNvbnRleHQ6IGdrZV9jb21tZXJjaWFsLXRyaWJlX3VzLWVhc3QxLWNfc3RhZ2luZw==).

<img width="100%" src="https://raw.githubusercontent.com/CommercialTribe/psykube/master/demo.gif"/>

## Commands

### `psykube init`
Generates a .psykube.yml in the current directory.

#### Usage:
`psykube init [flags...] [arg...]`

#### Flags:
| long              | short | default                              | description
| ----------------- | ----- | ------------------------------------ | --------------------------------------
| `--help`          |       |                                      | Displays help for the current command.
| `--env`           | `-e`  |                                      | Set an environment variable.
| `--file`          | `-f`  | `./.psykube.yml`                     | The location of the psykube manifest yml file.
| `--host`          | `-h`  |                                      | Set a host for ingress.
| `--image`         | `-i`  |                                      | Set the image, this takes precedence over `--registry-host` and `--registry-user`.
| `--name`          | `-N`  | current directory name               | Set the name of the application used for deployment.
| `--namespace`     | `-n`  |                                      | Set the namespace.
| `--overwrite`     | `-o`  | `false`                              | Overwrite the file if it exists.
| `--port`          | `-p`  |                                      | Set a port. (can be in the format of `--port 1234` or `--port http=1234`).
| `--registry-host` | `-R`  |                                      | The hostname for the registry. (use if not hosting on docker hub)
| `--registry-user` | `-U`  | current docker user                  | The username for the registry.
| `--tls`           | `-t`  | `false`                              | Enable TLS for ingress.

### `psykube generate`
Generate the kubernetes manifests.

#### Usage:
`psykube generate [flags...] <cluster> [arg...]`

#### Arguments
| name              | description
| ----------------- | ------------
| `cluster_name`    | the name of the cluster to generate the manifests for.

#### Flags:
| long              | short | default                              | description
| ----------------- | ----- | ------------------------------------ | --------------------------------------
| `--help`          |       |                                      | Displays help for the current command.
| `--file`          | `-f`  | `./.psykube.yml`                     | The location of the psykube manifest yml file.
| `--namespace`     | `-n`  |                                      | The namespace to use when invoking kubectl.
| `--image`         | `-i`  |                                      | Overrides the docker image.

### `psykube apply`
Apply the kubernetes manifests.

#### Usage:
`psykube apply [flags...] <cluster> [arg...]`

#### Arguments
| name              | description
| ----------------- | ------------
| `cluster_name`    | the name of the cluster to generate the manifests for.

#### Flags:
| long              | short | default                              | description
| ----------------- | ----- | ------------------------------------ | --------------------------------------
| `--help`          |       |                                      | Displays help for the current command.
| `--file`          | `-f`  | `./.psykube.yml`                     | The location of the psykube manifest yml file.
| `--namespace`     | `-n`  |                                      | The namespace to use when invoking kubectl.
| `--image`         | `-i`  |                                      | Overrides the docker image.
| `--build-args`    |       |                                      | The build args to add to docker build.
| `--context`       | `-c`  | The current context set for kubectl  | The context to use when invoking kubectl.
| `--copy-namespace`|       |                                      | Copy the specified namespace if the target namespace does not exist.
| `--force-copy`    |       | `false`                              | Copy the namespace even the destination already exists.
| `--push`          |       | `true`                               | Build and push the docker image.
| `--resources`     | `-r`  |                                      | The resource types to copy for copy-namespace.     

### `psykube push`
Build and push the docker image.

#### Usage:
  `psykube push [flags...] [arg...]`

#### Flags:
| long              | short | default                              | description
| ----------------- | ----- | ------------------------------------ | --------------------------------------
| `--help`          |       |                                      | Displays help for the current command.
| `--file`          | `-f`  | `./.psykube.yml`                     | The location of the psykube manifest yml file.
| `--build-args`    |       |                                      | The build args to add to docker build.
| `--tag`           | `-t`  |                                      | Additional tags to push.

### `psykube playground`
Start the playground.

#### Usage:
`psykube generate [flags...] [arg...]`

#### Flags:
| long              | short | default                              | description
| ----------------- | ----- | ------------------------------------ | --------------------------------------
| `--help`          |       |                                      | Displays help for the current command.
| `--bind`          | `-b`  | `127.0.0.1`                          | The address to bind to.
| `--port`          | `-p`  | `8080`                               | The port to bind to.
