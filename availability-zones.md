# Availability Zones [IN PROGRESS]

Currently to have a single deployment job span multiple AZs, one has to create multiple resource pools with slightly different cloud properties and also create multiple deployment jobs with slightly different names (e.g. web_z1, web_z2). Current approach works; however, it does introduce extra complexity in the deployment manifest which is not ideal for service brokers to deal when creating a deployment manifest.

To simplify AZs configuration, here is the list of proposed changes to the BOSH Director:

1. pull out AZs configuration into their own section

	Each availability zone specifies cloud_properties that include reference IaaS defined AZ (only placement information). For example on AWS it's `availability_zone` and vSphere it may be `cluster`.

2. have subnets of each network define which AZ they belong

	Each deployment job can be on one or more networks. Since each deployment job can span multiple AZs, there needs to be a way to determine how to describe a network that spans multiple AZs. Most IaaSes require a separate subnet per AZ, so BOSH can abstract that away by defining a network based on multiple subnets from different AZs.

3. stop referencing AZ related cloud properties in resource pools

	Resource pool's cloud_properties should only include VM sizing information such as instance types, RAM, CPUs, etc.

4. each deployment job specifies availability zones to be in

	TBD: how does `instances` value relates to `azs` e.g. when there are multiple availability zones, does instances specify number of instances per AZ or total?

5. expose availability zone information in deployment job templates during rendering

  Similarly to how `name`, `index` and `networks` properties are exposed, we can have `az` property with an AZ name.

Above changes result into something like this:

```yaml
azs: # <----- #1
- name: z1
  cloud_properties: {availability_zone: us-east-1a}
- name: z2
  cloud_properties: {availability_zone: us-east-1c}

networks:
- name: my-net
  type: manual
  subnets:
  - range: 10.0.0.0/24
    gateway: 10.0.0.1
    az: z1 # <----- #2
    cloud_properties: {subnet_id: subnet-27rh}
  - range: 10.0.1.0/24
    gateway: 10.0.1.1
    az: z1
    cloud_properties: {subnet_id: subnet-28fj}
  - range: 10.1.0.0/20
    gateway: 10.1.0.1
    az: z2
    cloud_properties: {subnet_id: subnet-14kh}

resource_pools:
- name: my-vms
  stemcell:
  	name: bosh-aws-xen-ubuntu-trusty-go_agent
  	version: 2889
  network: default
  cloud_properties: {instance_type: m1.small} # <----- #3

disk_pools:
- name: my-disks
  disk_size: 10_000
  cloud_properties: {type: gp2}

compilation:
  network: default
  cloud_properties: {instance_type: m1.small}

...

jobs:
- name: web
  instances: 3
  templates:
  - name: web
  azs: [z1, z2] # <----- #4
  resource_pool: my-vms
  persistent_disk_pool: my-disks
  networks:
  - name: my-net
```

## CLI changes / Job Instance Indexing

Currently job instances are referenced via `name/index`. With addition of AZs, some subset of deployment job instances are placed into one AZ and another subset is placed in another. When number of instances is scaled (either up or down), the Director should add/delete some number of instances to each AZ. Once new instances are added/deleted continious numeric indexing breaks down or becomes complicated. In addition to that user may increase/decrease number of AZs deployment job spans.

To make "naming" of deployment jobs easier across AZs, we can replace numeric indexing with unique id indexing. For example:

```
$ bosh vms
+-----------+---------+---------------+-------------+
| Job/index | State   | Resource Pool | IPs         |
+-----------+---------+---------------+-------------+
| lol_z1/0  | running | default       | 10.10.16.12 |
| lol_z1/1  | running | default       | 10.10.16.13 |
| lol_z2/0  | running | default       | 10.10.16.14 |
+-----------+---------+---------------+-------------+
```

could be something like this:

```
$ bosh vms
+-------------+------+---------+---------------+-------------+
| Job/index   | AZ   | State   | Resource Pool | IPs         |
+------- -----+------+---------+---------------+-------------+
| lol/e464... | z1   | running | default       | 10.10.16.12 |
| lol/b29f... | z1   | running | default       | 10.10.16.13 |
| lol/27e5... | z2   | running | default       | 10.10.16.14 |
+-------------+------+---------+---------------+-------------+
```

Other CLI commands that take name of a job instance will have to be adjusted. Director can allow usage of shortened id as long as they are unique within a deployment job. For example:

```
$ bosh ssh dumjob/e464
bash#

# Following commands are equivalent
$ bosh recreate dumjob/e464
$ bosh recreate dumjob/e4644870-5df3-439f-872c-e3a5836d2dba
```

Currently releases that require special bootstrapping node find it by checking `index==0`. Since indexing will not be numerical, a boolean can be introduced such that release jobs can check if an instance is a bootstrap instance. Job templates can use `spec.bootstrap==true`.

## Migrating data when collapsing deployment jobs

Currently to use multiple AZs separate deployment jobs are configured which use different resource pools. For example:

```
jobs:
- name: etcd_z1
  instances: 1
  templates:
  - name: etcd
  resource_pool: my-vms-z1
  persistent_disk_pool: my-disks
  networks:
  - name: my-net-z1
- name: etcd_z2
  instances: 1
  templates:
  - name: etcd
  resource_pool: my-vms-z2
  persistent_disk_pool: my-disks
  networks:
  - name: my-net-z2
```

To collapse two deployment jobs into one without losing persistent disks new deployment job must reference previous jobs:

```
jobs:
- name: etcd
  instances: 2
  templates:
  - name: etcd
  migrated_from:
  - name: etcd_z1
    az: z1  # this property is optional
  - name: etcd_z2
    az: z2  # this property is optional
  resource_pool: my-vms
  persistent_disk_pool: my-disks
  networks:
  - name: my-net
  azs: [z1, z2]
```

## Stories

[see `az` label in Tracker for created stories]

### ID vs Index

- determine if we should allow shorthand format
- support specifying id instead of index for getting details about specific vm
  - used where?
- deprecate index (X months out)
- depreacte release fixing on upload release

## TBD

* default AZ assigment
* index assignment per AZ?
* striping of persistent disks during migration
* should resurrector fall back to diff AZs for non-stateful nodes?
* static ips ordering when spanning multiple AZs
