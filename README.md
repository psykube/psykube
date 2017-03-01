<h1>Psykube&nbsp;&nbsp;<img height="50px" src="https://raw.githubusercontent.com/CommercialTribe/psykube/master/psykube-duck.png"/>&nbsp;&nbsp;a faster way to deploy to Kubernetes!&nbsp;&nbsp;<a href="https://travis-ci.org/CommercialTribe/psykube"><img src="https://travis-ci.org/CommercialTribe/psykube.svg?branch=master" /></a></h1>
[What is Psykube?](#what-is-psykube)
| [Installation](#installation)
| [The Psykube YAML](#the-psykube-yaml)
| [Cluster Assumptions](#cluster-assumptions)
| [Getting Started](#getting-started)
| [Commands](#commands)

---

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

**NOTE:** There is also an example .travis.yml file with an example of how to deploy to google container engine.

## Cluster Assumptions

Psykube works best with a certain kubernetes setup.

1. A cluster running that latest kubernetes. _(**NOTE:** psykube versions line up with kubernetes versions)_
1. [An ingress controller](https://kubernetes.io/docs/user-guide/ingress/#ingress-controllers).
1. [kube-lego](https://github.com/jetstack/kube-lego) controller installed for automatic TLS.

## Getting Started

To get started with psykube you can run the [`psykube init`](#psykube-init) command. You can then edit the `.psykube.yml` file generated in the current directory. By default, all that is generated is the application itself. In order to expose it to the web you must set ports and ingress. You can also use `tls: true` to tell `kube-lego` to generate a certificate and enable https for your ingress.

```yaml
name: hello-world
registry_user: johndoe
ports:
  http: 8080
ingress:
  tls: true
  host: hello-world.example.com
```

## Commands

### `psykube-init`
Generates a .psykube.yml in the current directory.

#### Usage:
`psykube init [flags...] [arg...]`

#### Flags:
| long              | short | default                              | description
| ----------------- | ----- | ------------------------------------ | --------------------------------------
| `--help`          |       |                                      | Displays help for the current command.
| `--env`           | `-e`  |                                      | Set an environment variable.
| `--file`          | `-f`  | `./.psykube.yml`                     | The location of the psykube manfest yml file.
| `--host`          | `-h`  |                                      | Set a host for ingress.
| `--image`         | `-i`  |                                      | Set the image, this takes precedence over `--registry-host` and `--registry-user`.
| `--name`          | `-N`  | current directory name               | Set the name of the application used for deployment.
| `--namespace`     | `-n`  |                                      | Set the namespace.
| `--overwrite`     | `-o`  | `false`                              | Overwrite the file if it exists.
| `--port`          | `-p`  |                                      | Set a port. (can be in the format of `--port 1234` or `--port http=1234`).
| `--registry-host` | `-R`  |                                      | The hostname for the registry. (use if not hosting on docker hub)
| `--registry-user` | `-U`  | current docker user                  | The username for the registry.
| `--tls`           | `-t`  | `false`                              | Enable tls for ingress.

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
| `--file`          | `-f`  | `./.psykube.yml`                     | The location of the psykube manfest yml file.
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
| `--file`          | `-f`  | `./.psykube.yml`                     | The location of the psykube manfest yml file.
| `--namespace`     | `-n`  |                                      | The namespace to use when invoking kubectl.
| `--image`         | `-i`  |                                      | Overrides the docker image.
| `--build-args`    |       |                                      | The build args to add to docker build.
| `--context`       | `-c`  | The current context set for kubectl  | The context to use when invoking kubectl.
| `--copy-namespace`|       |                                      | Copy the specified namespace if the target namespace does not exist.
| `--force-copy`    |       | `false`                              | Copy the namespace even the destination already exists.
| `--push`          |       | `true`                               | Build and push the docker image.
| `--resources`     | `-r`  | `cm, ds, secrets, deploy, pvc, limits, rc, svc, statefulsets` | The resource types to copy for copy-namespace.     

### `psykube push`
Build and push the docker image.

#### Usage:
  `psykube push [flags...] [arg...]`

#### Flags:
| long              | short | default                              | description
| ----------------- | ----- | ------------------------------------ | --------------------------------------
| `--help`          |       |                                      | Displays help for the current command.
| `--file`          | `-f`  | `./.psykube.yml`                     | The location of the psykube manfest yml file.
| `--build-args`    |       |                                      | The build args to add to docker build.
| `--tag`           | `-t`  |                                      | Additional tags to push.
