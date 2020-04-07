# Will create an empty psykube config file
```sh
psykube configure init --root .
```

This will use teeplate to write the config root as well as create the base templates.

# Will add a cluster and configure all of its resources & commands
```sh
psykube configure add-cluster dev [...opts]
```

Cluster config is to be stored in `.psykube-config/clusters.yml`
A git ignored runtime for each cluster will be stored in `.psykube-config/.cluster/bin/[command]`
this is where the cluster specific binaries will be stored

Example cluster config:

```yml
# .psykube/clusters.yml
dev:
  context: "[k8s context]"
beta:
  context: "[k8s context]"
prod:
  context: "[k8s context]"
```

# Will update a clusters resources and commands
```sh
psykube configure update-cluster dev
```

# Will add a template and compile it into the required commands, 
# NOTE: must run update-cluster after editing a template
```
psykube definition add [name]
psykube configure update-cluster --all
```

Templates are stored in `.psykube-config/definitions/[name]` as with the following files.

`definititions/[name]/manifest.yml`
```yml
root: "key"
properties:
  [key]: # Scalar
    type: string
  [key]: # Sub Object
    properties:
      [key]: string
  [key]: # Array of scalar
    array: string
  [key]: # Array of objects
    array:
      properties:
        [key]: string
```

`definititions/[name]/command.sh`
```sh
```

`definitions/[name]/templates/[name].ecr`
```ecr
```

# App Commands
```
psykube app init [name?]
psykube app deploy [build,apply]
psykube app build [cluster] [container]
psykube app 
```

