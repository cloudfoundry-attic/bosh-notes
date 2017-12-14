- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary
In a multi-AZ setup, BOSH should distribute the instances of an AZ to other AZs, in case an AZ fails completely.

# Motivation
An AZ failure currently means a degradation in service for users. Operators have to overprovision resources in each AZ, to maintain a certain quality of service. For example, when all Cells in an AZ go down, the Cells in the remaining AZs need to have enough spare capacity to host the application instances from the failed AZ. Maintaining this spare capacity just for AZ failover can become quite costly.

# Details
The cloud-config defines three AZs like this
```
azs:
- name: z1
  cloud_properties:
    availability_zone: us-east-1b
- name: z2
  cloud_properties:
    availability_zone: us-east-1c
- name: z3
  cloud_properties:
    availability_zone: us-east-1a
```

and the deployment manifest for cells looks like this
```
- name: diego-cell
  azs: [z1, z2, z3]
  instances: 90
  vm_type: small-highmem
  vm_extensions:
  - 100GB_ephemeral_disk
  stemcell: default
  networks:
  - name: default
  jobs:
(...)
```

Let's assume that AZ z2 fails, then BOSH should try to recreate all instances which are currently in z2 in either z1 or z3. That means, 30 instances get recreated in either z1 or z3.

For diego-cells, which don't have persistent storage, this should work on all IaaS. If persistent storage is involved, things get more involved:
* AWS doesn't allow attaching a disk from e.g. us-east-1b to a VM in us-east-1c. This would mean the recreated instances don't get their persistent disk re-attached, but an empty disk.
* GCP has the same restriction as AWS
* OpenStack can be configured such that
  * a VM and its persistent disk can be in different AZs
  * Storage AZs and Compute AZs are differently configured. If you're e.g. using Ceph, your storage backend handles AZs transparently while exposing only a single AZ to your users


Potential solutions for IaaS configurations which don't allow attaching a disk from a different Az
* GCP proposes to create a disk in the new AZ from a snapshot: https://cloud.google.com/compute/docs/instances/moving-instance-across-zones
* AWS supposedly works the same: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumes.html
* OpenStack *cannot* use the same 'create volume from snapshot' technique described above. 
* Azure doesn't have Availability Zones as a first-class construct yet. A VM recreated in a different Availability Set can attach the previous disk.

# Drawbacks

...

# Unresolved questions
* how to detect AZ failure?
* deal with IaaS that don't allow attaching storage from a different AZ
* how to pick the AZ for retry
* what happens when the AZ comes back? automated re-balance?
* Alternatives for OpenStack? Maybe transfer-volume or migrate-volume?
...
