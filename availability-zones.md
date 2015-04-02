# Availability Zones

Currently to have a single deployment job span multiple AZs, one has to create multiple resource pools with slightly different cloud properties and also create multiple deployment jobs with slightly different names (e.g. web_z1, web_z2). Current approach works; however, it does introduce extra complexity in the deployment manifest which is not ideal for service brokers to deal when creating a deployment manifest.

To simplify AZs configuration, here is the list of proposed changes to the BOSH Director:

1. pull out AZs configuration into their own section

	Each availability zone specifies cloud_properties that include reference IaaS defined AZ (only placement information). For example on AWS it's `availability_zone` and vSphere it may be `cluster`.

2. have subnets of each network define which AZ they belong

	Each deployment job can be on one or more networks. Since each deployment job can span multiple AZs, there needs to be a way to determine how to describe a network that spans multiple AZs. Most IaaSes require a separate subnet per AZ, so BOSH can abstract that away by defining a network based on multiple subnets from different AZs.

3. stop referencing AZ related cloud properties in resource pools

	Resource pool's cloud_properties should only include VM sizing information such as instance types, RAM, CPUs, etc.

4. each deployment job specifies availability zones to be in

	TBD: how does `instances` value relates to `availability_zones` e.g. when there are multiple availability zones, does instances specify number of instances per AZ or total?

Above changes result into something like this:

```yaml
availability_zones: # <----- #1
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
    availability_zone: z1 # <----- #2
    cloud_properties: {subnet_id: subnet-27rh}
  - range: 10.0.1.0/24
    gateway: 10.0.1.1
    availability_zone: z1
    cloud_properties: {subnet_id: subnet-28fj}
  - range: 10.1.0.0/20
    gateway: 10.1.0.1
    availability_zone: z2
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
  availability_zones: [z1, z2] # <----- #4
  resource_pool: my-vms
  persistent_disk_pool: my-disks
  networks:
  - name: my-net
```

## Stories

* user can specify list of availability zones
  - name is a required String
  - cloud_properties is a required Hash; with empty hash as a default
* user should see an error message if duplicate names are specified for AZs
* user can specify availability zone for a manual network's subnets
  - error if availability zone referenced is not found
* user can specify availability zones on a deployment job
  - error if availability zone referenced is not found
* user can see an error message when a deployment job in two AZs uses a manual network that does not have subnet in that AZ

* user can see deployment job VMs get AZ assigned to them based on specific AZ
  - create_vm CPI call gets sum of AZ's cloud_properties and resource pool's cloud_properties
* user can see deployment job VMs get IPs from AZ specific subnets of manual network

## TBD

* default AZ assigment
* index assignment per AZ
* striping of persistent disk
