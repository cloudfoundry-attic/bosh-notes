- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

As an operator, I expect that IaaS resources like stemcells are tagged with consistent set of tags (similar to VMs tags).

# Motivation

- easier to delete resources in bulk (as a brute force option)
- easier to integrate with IaaS cost tracking (AWS)

# Details

Currently stemcells are not tagged. VMs and disks are already tagged via `set_[vm/disk]_metadata` [1]. Let's add `set_stemcell_metadata(metadata)` to support custom tagging.

[1] https://github.com/cloudfoundry/bosh/blob/master/src/bosh-director/lib/bosh/director/metadata_updater.rb#L4

Both Director and create-env command should call this method, and ignore if it's not available.

## IaaS specifics

How/if do following IaaSes allow tagging of images?

- AWS
- Azure
- vSphere (F5 & NSX & NSX-T)
- OpenStack
- GCP
- Warden & Docker


# Drawbacks

...

# Unresolved questions

...
