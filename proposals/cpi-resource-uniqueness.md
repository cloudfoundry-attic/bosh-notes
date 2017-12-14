- State: discussing

# CPI Resource Uniqueness

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

## Potential resolutions

- add create_server_group CPI method that would be called before new instance group is made. additionally there would be delete_server_group CPI method that would be called when instance group is deleted.
  - is there a need for update_server_group?

`create_server_group (string name) returns string SERVER-GROUP-UUID`
* currently name is generated from concatenating `BOSH UUID` and `env.bosh.group`
* policy is always `soft-anti-affinity`, not set by the user

`delete_server_group(string SERVER-GROUP-UUID) returns nil`

Either `create_vm()` attaches VMs to server groups. Server group UUID should be provided by Director automatically in `cloud_properties.scheduler_hints` as additional variable, just like user currently does manually: http://bosh.io/docs/vm-anti-affinity.html#openstack.
Alternatively, we add `add_vm_to_server_group(string VM-UUID, string SERVER-GROUP-UUID)` as method. Removing method can either be added as well or handled through deletion of VM.

usage:
* global flag `enable_auto_anti_affinity: true` to have BOSH automatically assign all members of an instance group to a server group
* manual management of members for the server groups, in case you want to add multiple instance groups to the same server group: users may pass in a different name to their instance groups they want to have in the same server group with property 
