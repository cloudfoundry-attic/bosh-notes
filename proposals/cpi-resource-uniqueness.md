- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Make the CPI handle resources such as groups for anti-affinity or security groups more explicitly, to avoid mutex locking on the CPI side.

# Motivation

CPIs need to handle some resources more explicitly, such that a lifecycle can be controlled. Currently, creating and deleting e.g. server groups or availability sets for anti-affinity is done in `create_vm` and `delete_vm` implicitly. As those can be called in parallel, this requires locking on the CPI side to deal with race conditions. In many IaaS layers, CIDs are identifiers for resources, while the CPI identifies resources by their names. In those cases, no errors are raised when you create another resource with the same name. Therefore, CPIs need to check if a server group with a given name exists, before deciding to create it, leading to race conditions during parallel execution.

# Details

We've run into several cases when CPIs were not able to create unique resources based on resourece names because IaaS did not enforce naming uniquness.

Typically uniqueness is only checked for IDs.

Examples:

- OpenStack
  - server groups (anti affinity policy)
  - security groups (creation, deletion)
- vSphere
  - security groups (creation, deletion)
- Azure
  - removal of availability sets after all instances are deleted

All of these resources are unique for an instance group. To avoid locking in the CPI during `create_vm`, we add a new CPI method `create_server_group` that id be called **before** vms for an instance group are created. Additionally, we add a new CPI method `delete_server_group` that is called after all VMs of an instance group have been deleted.
  - is there a need for ?

`create_server_group (hash metadata) returns string SERVER-GROUP-CID`
* Depending on IaaS restrictions, CPIs can decide how to name the server group. All of the metadata information is derived from the manifest/cloud-config. The metadata hash looks like this
```
{
  director: {
    name: "production-director",
    uuid: "abcd-2134-5678"
  },
  deployment: "kafka",
  instance_group: "my_instance_group",
  azs: ["z1", "z2", "z5"],
  security_groups: ["group1", "bosh", "another_group"]
  },
}
```
The CPI then can
 * check if security groups with this name exist, if not, create
 * check if server groups with some generated name exist, if not, create
 * so far, policy for anti-affinity-groups is always `soft-anti-affinity`, not set by the user. We could allow for specifying this in the manifest and push it into the metadata hash as well.

Returned `SERVER-GROUP-CID` is used to identify the group in the IaaS. The Director stores the `SERVER-GROUP-CID` in a new table `server_groups`, with association to `instance_groups`.



`delete_server_group(string SERVER-GROUP-CID) returns nil`

VMs are attached to server groups in `create_vm()`. The `SERVER-GROUP-CID` is passed in as `env.bosh.server_group_cid`.
VMs are removed from server groups in `delete_vm`.

usage:
* global flag `enable_auto_anti_affinity: true` to have BOSH automatically assign all members of an instance group to a server group
* manual management of members for the server groups, in case you want to add multiple instance groups to the same server group: users may pass in a different name to their instance groups they want to have in the same server group with property 

# Unresolved questions
* How to extend to other resources, e.g. security groups? CPI needs some concept to distinguish wether this is a Security Group or an Availability Set
* Is 'server group' a good name for this? Are we really grouping servers? And: on OpenStack, server group is already a thing
* Method seems weird: input is metadata, it may do a lot of things, but only returns a single CID of a single object? What about other things, do we need to make the returned hash more generic?
* `bosh create-env` needs to deal with some of the resources as well, e.g. security groups
* is there a need for `update_server_group`?
* are some resources specific to an AZ?
