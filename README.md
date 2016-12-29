# Psykube
A tool for managing the Kubernetes lifecycle of a single container application.

# Installation
Visit the releases tab on github, and install the latest version for your OS.

# Usage
`psykube [command] [arguments]`

# Commands

## `apply <cluster>`
Applies the generated kubernetes manifests for the specified cluster.

## `copy-namespace <from> <to>`
Copies a kubernetes namespace and (most) of its resources to a new namespace.

## `delete <cluster>`
Deletes all associated kubernetes manifests for the current app.

## `exec <command>`
Finds a running pod belonging to this app and executes a command within it.

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

### TODO!
