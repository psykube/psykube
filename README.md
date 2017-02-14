# Psykube
[![Build Status](https://travis-ci.org/CommercialTribe/psykube.svg?branch=master)](https://travis-ci.org/CommercialTribe/psykube)

A tool for managing the Kubernetes lifecycle of a single container application.

![Psykube Duck](https://raw.githubusercontent.com/CommercialTribe/psykube/master/psykube-duck.png)

# Installation

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
