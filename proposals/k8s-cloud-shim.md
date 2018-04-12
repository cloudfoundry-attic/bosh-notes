- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related: [disks-api.md](https://github.com/cloudfoundry/bosh-notes/blob/master/proposals/disks-api.md)

# Summary

Director (and an additional component) should provide APIs to fulfill typical Kubernetes cloud provider to manage persistent disks (CSI), load balancers, networks, and VMs (cluster API).

# Motivation

...

# Details

## Disks

- ability to create disks
  - POST /disks -d '{ "cloud_properties": { ... } [ "az": ??? | "vm_cid": ??? | "deployment": ??? ] }'
    - does Kubernetes know which AZ to use?
    - associate disk to a deployment
- ability to attach disks to particular VM CID
  - PUT /disks/:disk_cid/attachments?vm_cid=...
    - should we use instance_id?
    - check VM against user token's teams
- ability to detach disk
  - DELETE /disk_attachments/xxx
    - TBD: who garbage collects orphaned disk if we mark it as dont delete me (no deployment would be using it)
    - TBD: empty deployment that keeps disk in it to avoid orphaning?
- ability to delete disks
  - DELETE /disks/:disk_cid
    - will oprhan it actually
    - want to check that disk is associated with a deployment (nice for security)

# Drawbacks

- API is provided by the Director, so if Director is not available then Kube calls will be in queued state.

# Unresolved questions

- TBD: `bosh clean-up --team ... --deployment ...?` for SB to delete assets of a deployment/team
