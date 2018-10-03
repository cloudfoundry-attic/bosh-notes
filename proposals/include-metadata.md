- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

CPI should pass metadata information as part of create_vm and create_disk call

# Motivation

To be able to use this metadata information e.g deployment_name/instance_group name during vm_creation.
VM CID can be prefixed with instance_group name so that it is easy to identify VM in vCenter.
Created disk could also be organized using this metadata information
 
# Details

Metadata will include basic information about director, deployment and instance_group. E.g

```
{
  director_name: "production-director",
  director_uuid: "abcd-2134-5678"
  deployment_name: "kafka",
  instance_group: "my_instance_group",
  }

```
 
create_vm interface will now be:

```create_vm(agent_id, stemcell_cid, cloud_properties, network_settings, disks, env, metadata)```

create_disk interface will now be:

```create_disk(size, cloud_properties, vm_locality, metadata)```

Information provided in metadata is right now passed as part of groups array inside env hash. CPI is not supposed to 
rely on this information. Adding new argument metadata will make this data more reliable and useful for various IAAS.

There have been request for this from different IAAS as well. See Issue #[62](https://github.com/cloudfoundry/bosh-aws-cpi-release/issues/62), Issue #[1163](https://github.com/cloudfoundry/bosh/issues/1163) 
 
# Drawbacks

Change to CPI contract

# Unresolved questions

What other information can be added as part of this set?