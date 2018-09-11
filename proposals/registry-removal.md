- State: in-progress

# Summary

BOSH currently contains Registry component which it technically does not need.

# Details

We can simplify Director-CPI-Agent communication by removing Registry and sending necessary persistent disks information directly to the Agent.

## CPI updates

API version 2 of CPIs will differ from version 1 by the following:

 - Director will send cpi api_version based on info response from for all CPI calls
 - Director will also send stemcell `api_version` for all CPI calls
 - Director will be expecting V2 responses IF 
   - CPI info call provide max supported version as >=2 AND 
   - Stemell api_version is >=2 AND
   - `api_version` 2 is requested in the call
  
  
  ```json
   "context": {
    "director_uuid": "<director-uuid>",
    "request_id": "<cpi-request-id>",
    "vm": {
      "stemcell": {
        "api_version": 2
      }
    }
  },
  "api_version": 2
  ```

- **`info`** should also provide `api_version` to let the consumer understand the `MAX` supported version

  ***NOTE:*** all CPI need to support CPI v1 contracts for backward compatibility

Request:

 - Initial (first) call to info will not have any additional `context` regarding `api_version`

```json
{
  "method": "info",
  "arguments": [],
  "context": {
    "director_uuid": "<director-uuid>",
    "request_id": "<cpi-request-id>"
  }
}
```

Response:

```json
{
  "api_version": 2,
  "stemcell_formats": [
    "aws-raw",
    "aws-light"
  ]
}
```


- **`create_vm`** will return network configuration in addition to returning VM CID

Request:

```json
 {
  "method": "create_vm",
  "arguments": [
    "<agent-id>", //in
    "<stemcell-id>",
    { 
      // ... cloud-properties ...
    },
    { 
      // ... networks ... 
    },
    [
      // ... disk_cids ...
    ],
    {
      // ... agent_env ...
    }
  ],
  "context": {
    "director_uuid": "<director-uuid>",
    "request_id": "<cpi-request-id>",
    "vm": {
      "stemcell": {
        "api_version": 2
      }
    }
  },
  "api_version": 2
}
```

Response:

```json
{
  "result": [
    "<instance-id>",
    { //network
      "default": {
        "type": "manual",
        "ip": "10.0.1.4",
        "netmask": "255.255.255.0",
        "cloud_properties": {
          "subnet": "subnet-d5b905f8"
        },
        "default": [
          "dns",
          "gateway"
        ],
        "dns": [
          "8.8.8.8"
        ],
        "gateway": "10.0.1.1"
      }
    }
  ],
  "error": null,
  "log": ""
}
```


- **`attach_disk`** will return disk hint as its result

Request:

```json
{
  "method": "attach_disk",
  "arguments": [
    "i-0a8d6e89b06c7ef25",
    "vol-01aad1d6b3149cca1"
  ],
  "context": {
	 "director_uuid": "<director-uuid>",
    "request_id": "<cpi-request-id>",
    "vm": {
      "stemcell": {
        "api_version": 2
      }
    }
  },
  "api_version": 2
}
```

Response:

```json
{
	//disk hint response (string/hash)
  "result": "/dev/sdf",
  "error": null,
  "log": ""
}
```

- **`detach_disk`** does not change since it should be able to determine disk by disk CID

Request:

```json
{
  "method": "detach_disk",
  "arguments": [
    "i-0377ec1efc3f06cf8",
    "vol-044c8ae985721d217"
  ],
  "context": {
	 "director_uuid": "<director-uuid>",
    "request_id": "<cpi-request-id>",
    "vm": {
      "stemcell": {
        "api_version": 2
      }
    }
  },
  "api_version": 2
}
```

Response:

```json
{
  "result": true,
  "error": null,
  "log": ""
}
```


## How to update CPI to support new contracts:

#### CPI Changes with V2 contracts:

- CPI `info` method should expose `api_version` supported
- CPI V2 should use stemcell `api_version` to differenciate behaviour from older agents
  
#### Agent changes with V2 contracts:

- Agent will now first check metadata service to get settings (for `settings.json`) before falling back to registry (if registy URL is specified in the metadata service)
- With new contracts agent will save disk_hints (`persistent_disk_hints.json`) locally and use it to mount/unmount disks


#### Stemcell changes with V2 contracts:

- `stemcell.MF` should contain `api_version` if it contains a v2 supported agent in it, so that director, cpi and cli can support not usage of registry.
	-  if api_version is not provided in the `stemcell.MF` it treats it as api_version 1
	-  in order to get new behaviour `api_version > 1`

```yaml
---
#### stemcell api_version
api_version: 2
name: bosh-aws-xen-hvm-ubuntu-trusty-go_agent
version: '3546.14'
bosh_protocol: '1'
sha1: c186de6ef6e034bc93513440b9071b5f4696fa32
operating_system: ubuntu-trusty
stemcell_formats:
- aws-light
cloud_properties:
  ami:
    us-east-1: ami-xxxxxx
    us-west-1: ami-xxxxxx
```


All the updated contracts required for V2 support are published in the latest `bosh-cpi-ruby` gem [v2.5.0](https://github.com/cloudfoundry/bosh-cpi-ruby/releases/tag/v2.5.0)




## Director updates

- should expect getting list of networks from `create_vm`

- should forward the hints from `attach_disk` CPI call
  - calls `mount_disk` Agent method with disk hint for that disk

- `detach_disk` CPI call should stay the same
	- calls `unmount_disk` Agent method exactly the same way

## API Calls Flow

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


## Details broken down (for all combination)


### CLI:

- assume: should continue to work with old cpis

- cli will read `sc_api_version` from stemcell metadata & propagate to cpi
  - if no `sc_api_version` then 1
- cli will ask cpi which `cpi_api_version ` it has
  - if no `cpi_api_version` then 1

- if `cpi_api_version`>=2 && `sc_api_version`>=2
  - call new cpi methods (new signatures)
  - issue new agent commands for disks
  - (regisry wouldnt be started based on manifest conf)
    - experimental/ ops file to remove ssh_tunnel

- if `cpi_api_version`>=2 && `sc_api_version`==1
  - do existing flow. `sc_api_version` implies cpi response version. we use cpi version to determine response when `sc_api_version` == 2

- if `cpi_api_version `==1 && `sc_api_version`==1
  - do existing flow

- if `cpi_api_version `==1 && `sc_api_version`>=2
  - do existing flow


### Director:
- assume: should continue to work with old cpis/stemcells

- director will read `sc_api_version` from stemcell metadata
  - record in db? during upload of stemcell
    - newer stemcells imported into older directors will be considered old
  - if no sc api versin then 1
- director will ask cpi which `cpi_api_version ` it has
  - might have to do before calling cpi for the first time
  - if no cpi api versin then 1

- if `cpi_api_version `>=2 && `sc_api_version`>=2
  - create_vm doesnt change
    - except we want to save return values
  - attach_disk return values are sent to mount_disk
  - detach_disk doesnt change
    - director to keep track of disks
  - call agent with new agent signatures

- if `cpi_api_version `>=2 && `sc_api_version`==1
  - do existing flow

- if `cpi_api_version `==1 && `sc_api_version`==1
  - do existing flow

- if `cpi_api_version `==1 && `sc_api_version`>=2
  - do existing flow

- director requires mbus/ntp/blobstore.* config inside agent.env job property
  - so that colocated cpis dont have to worry about it


### CPI:
- assume: if `cpi_api_version `=2 then assume it supports v1

- if sc_api_verison>=2 found inside context
  - then do not update registry
  - (director passes down `sc_api_version` to the cpi)

- if `sc_api_version`<2 found inside context
  - require mbus/ntp/blobstore.* config to be merged into settings

- cpi should not require registry/mbus/ntp/blobstore.* job properties

- pr/issue for aws, vsphere, ... cpis


### Stemcell:
- include sc_api_verison for heavy stemcells
  - after we bump agent that includes this functionality
- include `sc_api_version` for light stemcells
- include sc_api_verison for windows stemcells


### Agent:
- if metadata service provides the required info that agent request from registry, agent will not call registry
- it explicitly check for presence of `agent_id` in metadata service to justify that all settings should be present in metadata



~~~TBD: should we backport agent changes to be sc_api_verison=2?~~~~


### Reference Table (Based on each component version)
* Reg./reg. : Registry

| Director | CPI | Stemcell  | Should update Reg.   | Add agent setting to Iaas `user-metadata`   |
|----------|-----|-----------|----------------------|---|
| 1  | 1  | 1  | Update Reg.  | Dont add agent setting to iaas  |
| 1  | 1  | 2  | Update Reg.  | Dont add agent setting to iaas  |
| 1  | 2  | 2  | Update Reg.  | Dont add agent setting to iaas  |
| 2  | 2  | 2  | DON'T add anything to reg.   | Yes, agent will read `user-metadata` and not call reg.  |
| 1  | 2  | 1  | Update Reg.  | Dont add agent setting to iaas  |
| 2  | 2  | 1  | Update Reg.  | Dont add agent setting to iaas (no agent support)  |
| 2  | 1  | 1  | Update Reg. (cpi will by default update reg.)  | Dont add agent setting to iaas |
| 2  | 1  | 2  | Update Reg. (cpi will by default update reg.)  | Dont add agent setting to iaas |


### Reference pipeline to test  CPI with all combination of Director, CLI and  Stemcell
[Pipeline for CPI V2 testing]( https://github.com/cloudfoundry-incubator/bosh-aws-cpi-release/blob/49447ba7ee208c31dddc1b7e3ec2a5f05c88ea99/ci/pipeline_cpi_v2.yml.erb)

---

**NOTE:** Few other combination should be taken under consideration

- Which version of cpi is specified in cpi.json
- director is adding `cpi_api_version ` in its properties or not
- **FOR Test phase**: is director specifying [`cpi_api_test_max_version`](https://github.com/cloudfoundry-incubator/bosh-cpi-certification/blob/master/aws/assets/ops/director_cpi_version.yml) in its properties or not
- On CPI side you can specify cpi version for debugging:

```yaml
 debug.cpi.api_version:
    description: api_version supported by cpi (can be used as an override for fallback).
    default: null
```

