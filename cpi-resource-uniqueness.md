# CPI Resource Uniqueness

We've run into several cases when CPIs were not able to create unique resources based on resourece names because IaaS did not enforce naming uniquness.

Typically uniqueness is only checked for IDs.

Examples:

- OpenStack
  - server groups (anti affinity polcity)
  - security groups (creation, deletion)
- vSphere
  - security groups (creation, deletion)
- Azure
  - removal of availability sets after all instances are deleted

## Potential resolutions

- add create_server_group CPI method that would be called before new instance group is made. additionally there would be delete_server_group CPI method that would be called when instance group is deleted.
  - is there a need for update_server_group?
