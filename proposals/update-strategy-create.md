- State: in-progress

## Update Strategy: Create (aka hotswap)

Currently default update strategy Director uses to update instances is `replace`.

For example here is how `replace` strategy would update 5 instances within a single instance group and when max_in_flight is 1. The Director will stop jobs on the first instance, delete that VM, create new VM in its place and start jobs. Once that's successful it will move onto the next instance.

There are several advantages to a different update strategy:

- speed up VM creation via bulk create operation
  - earlier feedback on IaaS capacity restrictions
- smaller individual job downtime as time between stopping and starting jobs is decreased
- delayed VM deletion (to speed up deployment)

`create` strategy: The Director will create all new VMs, stop jobs on the first instance, start jobs on the new VM for that first instance. Once that's successful it will move onto the next instance. Unused VMs will be considered orphaned and could be deleted after deploy has finished.
