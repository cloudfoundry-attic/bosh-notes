# Cloud Config [IN PROGRESS]

To keep service brokers (and other users of BOSH) IaaS agnostic, IaaS resource configuration (networks, resource_pools, disk_pools, compilation) can be configured per the Director such that service brokers only references those resources by name.

Currently deployment manifests include all IaaS specific resource configuration for that deployment. For example:

```yaml
name: my-deployment

networks:
- name: my-net
  type: manual
  subnets:
  - range: 10.0.0.0/24
    gateway: 10.0.0.1
    cloud_properties: {subnet_id: subnet-27rh}

resource_pools:
- name: small
  stemcell:
  	name: bosh-aws-xen-ubuntu-trusty
  	version: 2889
  network: my-net
  cloud_properties:
  	availability_zone: us-east-1a
  	instance_type: m1.small
  env:
    bosh:
      password: ...

disk_pools:
- name: small
  disk_size: 10_000
  cloud_properties: {type: gp2}

compilation:
  network: my-net
  cloud_properties:
  	availability_zone: us-east-1a
  	instance_type: m1.small

jobs:
- name: web
  instances: 1
  templates:
  - name: web
  resource_pool: small
  persistent_disk_pool: small
  networks:
  - name: my-net
```

For example, `iaas.yml` would look something like this:

```yaml
networks:
- name: my-net
  type: manual
  subnets:
  - range: 10.0.0.0/24
    gateway: 10.0.0.1
    cloud_properties: {subnet_id: subnet-27rh}

vm_types:
- name: small
  cloud_properties:
  	availability_zone: us-east-1a
  	instance_type: m1.small

disk_types:
- name: small
  disk_size: 10_000
  cloud_properties: {type: gp2}

compilation:
  workers: 5
  network: my-net
  cloud_properties:
  	availability_zone: us-east-1a
  	instance_type: m1.small
```

And to apply such configuration `update cloud-config` would be used:

```
# saves cloud config to the Director
$ bosh update cloud-config ./iaas.yml

# outputs saved config to stdout
$ bosh cloud-config
```

Since IaaS configuration is in a separate file, deployment manifest will only include deployment specific configuration:

```yaml
name: my-deployment

releases:
- {name: web, version: 20}

stemcells:
- alias: default
  os: ubuntu-trusty
  version: 3072

jobs:
- name: web
  instances: 1
  templates:
  - {name: web, release: web}
  vm_type: small
  stemcell: default
  persistent_disk_type: small
  networks:
  - name: my-net
```

And to deploy it:

```
# set current deployment
$ bosh deployment ./my-deployment.yml

# uses latest cloud config
$ bosh deploy
```

## Stemcells

Stemcell is picked automatically based on an OS and version provided. If none of the uploaded stemcells match, error is raised during a deploy.

```yaml
stemcells:
- alias: default
  os: ubuntu-trusty
  version: 3074
```

You can specify `name` instead of an OS for an exact stemcell match:

```yaml
stemcells:
- alias: default
  name: bosh-aws-xen-hvm-ubuntu-trusty-go_agent
  version: 3074
```

## Stories

[see `cloud-config` label in Tracker for created stories]

- user can specify disk_pools as disk_types (2)
  - keep supporting disk_pools
  - persistent_disk_pool on a job can be specified as persistent_disk_type
- user can specify stemcells in deployment manifest with a unique alias (2)
  - error if alias is duplicate
  - required: alias, version, os|name
- user can see error message if os/version combo does not match any uploaded stemcell (2)
  - pick first stemcell just like during export release
  - during bosh deploy (in binding stemcells stage)
- user can specify exact stemcell name to match (2)
  - error if name/version does not match uploaded stemcell
- user can use version=latest in stemcells section (4)
  - resolved in CLI just like for releases
- user can specify vm_types in cloud config (1)
  - error if name is duplicate
  - cloud_properties is optional
- user can specify vm_type+stemcell instead of resource_pool on job (2)
  - keep supporting resource_pool
  - vm_types+stemcell must be found
- user can only specify either resource_pools or vm_types+stemcells (1)
  - existence of a resource pool in cloud-config or dep man should raise an error when vm_types/stemcells are specified
- VMs should be recreated if either stemcell or vm_type changes (4)
  - for vm_types rely on cloud_properties (if names change, do not do anything)
  - if stemcell changes
  - switching between stemcell name vs os should not recreate if stemcell is the same
  - transition between res_pool -> vm_type/stemcell may result in recreation

## TBD

* deprecate old style deployment manifest
* view cloud config at some version
* `bosh deployments` shows cloud-config?
* clean up old cloud config (rollback?)
* extract stemcell info from resource pool
* show diff before deploying
* use vm_type for compilation
