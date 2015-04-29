# Cloud Config

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
- name: my-vms
  stemcell:
  	name: bosh-aws-xen-ubuntu-trusty
  	version: 2889
  network: my-net
  cloud_properties:
  	availability_zone: us-east-1a
  	instance_type: m1.small

disk_pools:
- name: my-disks
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
  resource_pool: my-vms
  persistent_disk_pool: my-disks
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

resource_pools:
- name: my-vms
  stemcell:
  	name: bosh-aws-xen-ubuntu-trusty
  	version: 2889
  network: my-net
  cloud_properties:
  	availability_zone: us-east-1a
  	instance_type: m1.small

disk_pools:
- name: my-disks
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

jobs:
- name: web
  instances: 1
  templates:
  - name: web
  resource_pool: my-vms
  persistent_disk_pool: my-disks
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

## Stories

[see `cloud-config` label in Tracker for created stories]

* user can deploy two deployments on a shared manual network and the Director picks next available IP for the second VM (8)
* user should see an error message if two deployments try to request same static IP
  - include name of the deployment that owns it
* user can deploy a VM with a static IP once it is released from a different deployment
  - so that to see static IPs are reused across deployments

## TBD

* validate cloud config before saving it
* deprecate old style deployment manifest
* view cloud config at some version
* `bosh deployments` shows cloud-config?
* clean up old cloud config (rollback?)
* extract stemcell info from resource pool
* show diff before deploying
