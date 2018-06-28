- State: discussing

# CPI cleanup Method

Some CPIs create resources that currently need to be cleaned up manually. Otherwise, they pile up and might cause a problem in the future. The canonical solution to avoid these problems should be to call `bosh cleanup` in regular intervals.

## Collection of resources which might hang around

Azure CPI:
* **Availability Sets** are automatically created based on `bosh.group` of an instance_group, but there is a quota on them. See https://docs.microsoft.com/en-us/azure/azure-subscription-service-limits
  * Even compilation VMs receive an Availability Set.

OpenStack CPI:
* **Server Groups** could be automatically created (similar to Azure Availability Sets). See https://www.pivotaltracker.com/story/show/135846431. Similar problems apply as with AS in Azure.
* Sometimes VM creation runs into `timeout` on the Director side, but eventually the VM *does* come up. The Director doesn't have this VM in its DB and will never clean it up.

vSphere CPI:
* **DRS Rules** are automatically created (similar to Azure Availability Sets). Not sure how they're cleaned up and if this might lead to problems at some point?

* **folders** (in datastores and clusters view)

AWS CPI: ???

GCP CPI: ???

Other CPIs: ???

As all of the details like kind of resources, etc. are IaaS specific, we propose adding a `cleanup` method to the CPI that can be called by the Director when the user executes `bosh cleanup`.

CPIs deal with types of resources, i.e. VMs, Disks, Snapshots, Stemcells. For some of those resources, cleaning up seems to work nicely. All others (see previous section), should be handled in the new CPI cleanup method. Resources the CPI doesn't create (e.g. networks) should not be treated in this method.

## Possible Implementations of `cleanup`
For a given set of resources, check if a resource is 'unused' (e.g. no VM using an Availability Set, a VM unknown to the Director). If unused, delete it. The question is: How to determine the list of resources?

* OptionA: All resources the CPI has access to
  * Pro:
    * requires no modification to the resources itself
    * works on all IaaS
  * Con:
    * Dangerous: Can we safely assume that all resources we find had been created by the CPI? We probably don't want to delete things a human created manually or through some other process.
    * Additional caution/isolation required by users. I.e. using multiple directors deploying in the same network is now impossible

* OptionB: Tag all resources with some well-known identifier (e.g. some generated CPI or Director ID) to filter
  * Pro:
    * Ensure that this Director/CPI has created those resources, no additional isolation necessary
  * Con:
    * Not all IaaS know about tags. How to deal with this on vSphere? Is it all about directories?

* OptionC: ???
