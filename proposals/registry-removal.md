- State: in-progress

# Summary

BOSH currently contains Registry component which it technically does not need.

# Details

We can simplify Director-CPI-Agent communication by removing Registry and sending necessary persistent disks information directly to the Agent.

## CPI updates

API version 2 of CPIs will differ from version 1 by the following:

- `create_vm` will return network configuration in addition to returning VM CID
  - `{"private": ..., "public": ...}`

- `attach_disk` will return disk hint as its result

- `detach_disk` does not change since it should be able to determine disk by disk CID

## Director updates

- should expect getting list of networks from `create_vm`

- should forward the hints from `attach_disk` CPI call
  - calls `mount_disk` Agent method with disk hint for that disk

- `detach_disk` CPI call should stay the same
	- calls `unmount_disk` Agent method exactly the same way

## Sample API Calls

```
# a new vm gets created (v2 is now with networking)
$ create_vm(...)
[ "vm-32r7834yt834", 
  {"private": { "type": "manual", "netmask": "255.255.255.0", "gateway": "10.230.13.1", "ip": "10.230.13.6", "default": [ "dns", "gateway" ], "cloud_properties": { "net_id": "d29fdb0d-44d8-4e04-818d-5b03888f8eaa" }}, 
    "public":  { "type": "vip", "ip": "173.101.112.104", "cloud_properties": {}} 
  }
]

# in the case where we need a new IaaS disk (same as before)
$ create_disk(...)
"disk-39748564"

# request the cpi attaches a disk and returns a hint about where the director should mount the disk
$ attach_disk("vm-32r7834yt834", "disk-39748564")
"/dev/sdc"
# now we director knows the hint about where the disk is mounted (contract between agent + cpi)
# director will be sure to record the hint for future operations

  # internally, we'll then call agent's mount_disk with the hint
  # "find disk-39748564 which should be mounted at /dev/sdc"
  agent$ mount_disk("disk-39748564", "/dev/sdc")

# attaching a (another) disk (future-ish for multiple persistent disk support)
$ attach_disk("vm-32r7834yt834", "disk-54367")
"/dev/sdd"
```

## Details broken down

```
cli:
- assume: should continue to work with old cpis

- cli will read sc_api_version from stemcell metadata & propagate to cpi
  - if no sc api versin then 1
- cli will ask cpi which cpi_api_version it has
  - if no cpi api versin then 1

- if cpi_api_version>=2 && sc_api_version>=2
  - call new cpi methods (new signatures)
  - issue new agent commands for disks
  - (regisry wouldnt be started based on manifest conf)
    - experimental/ ops file to remove ssh_tunnel

- if cpi_api_version>=2 && sc_api_version==1
  - ??? TBD: how do we know if cpi does not work with v1 contract?
    - probably noop

- if cpi_api_version==1 && sc_api_version==1
  - do existing flow

- if cpi_api_version==1 && sc_api_version>=2
  - do existing flow


director:
- assume: should continue to work with old cpis/stemcells

- director will read sc_api_version from stemcell metadata
  - record in db? during upload of stemcell
    - newer stemcells imported into older directors will be considered old
  - if no sc api versin then 1
- director will ask cpi which cpi_api_version it has
  - might have to do before calling cpi for the first time
  - if no cpi api versin then 1

- if cpi_api_version>=2 && sc_api_version>=2
  - create_vm doesnt change
    - except we want to save return values
  - attach_disk return values are sent to mount_disk
  - detach_disk doesnt change
    - director to keep track of disks
  - call agent with new agent signatures

- if cpi_api_version>=2 && sc_api_version==1
  - do existing flow

- if cpi_api_version==1 && sc_api_version==1
  - do existing flow

- if cpi_api_version==1 && sc_api_version>=2
  - do existing flow

- director requires mbus/ntp/blobstore.* config inside agent.env job property
  - so that colocated cpis dont have to worry about it


cpi:
- assume: if cpi_api_version=2 then assume it supports v1

- if sc_api_verison>=2 found inside context
  - then do not update registry
  - (director passes down sc_api_version to the cpi)

- if sc_api_version<2 found inside context
  - require mbus/ntp/blobstore.* config to be merged into settings

- cpi should not require registry/mbus/ntp/blobstore.* job properties

- pr/issue for aws, vsphere, ... cpis


stemcell:
- include sc_api_verison for heavy stemcells
  - after we bump agent that includes this functionality
- include sc_api_version for light stemcells
- include sc_api_verison for windows stemcells


agent:
- [done]


TBD: should we backport agent changes to be sc_api_verison=2?
```
