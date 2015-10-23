# CPI API v2 [PLANNING]

Remove registry and NATS from the Director/Agent data path:

- director and agents communicate directly instead of over NATS
  - switch to using HTTPS
- settings are sent directly to the agent instead of saved in the registry
  - e.g. send update_settings to the agent after attach_disk CPI, before mount_disk

Implications for the CPI API:

The CPI used to get and set settings in the registry. To remove the registry the API methods need to take a settings json as an additional argument and return the modified settings json. Settings remain opaque to the director, which just passes the settings on to the agents directly.

The following API methods read from and write to the registry and need to be adapted:

- `create_vm`
- `configure_networks`
- `attach_disk`
- `detach_disk`

## create_vm(...)

Arguments:

- stemcell_cid [String]: Cloud ID of the stemcell to use as a base image for new VM.
resource_pool_properties [Hash]: Cloud properties hash specified in the deployment manifest under VM’s resource pool.
- agent_bootstrap_settings [Hash]: Initial agent settings.
- networks_settings [Hash]: Networks hash that specifies which VM networks must be configured.
- disk_cids [Array of strings] Array of disk cloud IDs for each disk that created VM will most likely be attached; they could be used to optimize VM placement so that disks are located nearby.
- environment [Hash]: Resource pool’s env hash specified in deployment manifest.
Example

Note: CPIs and the Director will duplicate code (simple merge) for merging agent_bootstrap_settings + network_settings + disk_settings.

```
[
    "ami-478585",
    { "instance_type": "m1.small" },
    {
        ...
    },
    {
        "private": {
            "type": "manual",
            "netmask": "255.255.255.0",
            "gateway": "10.230.13.1",
            "ip": "10.230.13.6",
            "default": [ "dns", "gateway" ],
            "cloud_properties": { "net_id": "subnet-48rt54" }
        },
        "private2": {
            "type": "dynamic",
            "cloud_properties": { "net_id": "subnet-e12364" }
        }
        "public": {
            "type": "vip",
            "ip": "173.101.112.104",
            "cloud_properties": {}
        }
    },
    [ "vol-3475945" ],
    {}
]
```

Returned

- vm_cid [String]: Cloud ID of the created VM.
- net_settings [Hash]
- disk_settings [Hash]

```
[
	"i-0478554",
	{
        "private": {
            "type": "manual",
            "netmask": "255.255.255.0",
            "gateway": "10.230.13.1",
            "ip": "10.230.13.6",
            "default": [ "dns", "gateway" ],
            "cloud_properties": { "net_id": "d29fdb0d-44d8-4e04-818d-5b03888f8eaa" }
        },
        "public": {
            "type": "vip",
            "ip": "173.101.112.104",
            "cloud_properties": {}
        }
    },
	{
        "system": "/dev/sda",
        "ephemeral": "/dev/sdb",
        "persistent": {}
    }
]
```

## configure_networks(server_id, network_agent_settings)

Remove this method entirely from the API.

Note: This means that the CPI might not use the most efficient method to apply the desired configuration. E.g. changing VIP configuration requires re-creating the VM instead of detaching/attaching a VIP.

## attach_disk(server_id, disk_id)

Arguments:

- vm_cid [String]: Cloud ID of the VM.
- disk_cid [String]: Cloud ID of the disk.
- disk_settings [Hash]

Returned

- disk_agent_settings [Hash]: Updated disk settings

```
{
	"system": "/dev/sda",
	"ephemeral": "/dev/sdb",
	"persistent": {
	    "vol-3475945": { "volume_id": "3" },
	    "vol-7447851": { "path": "/dev/sdd" },
	}
}
```


## detach_disk(server_id, disk_id)

Arguments:

- vm_cid [String]: Cloud ID of the VM.
- disk_cid [String]: Cloud ID of the disk.
- disk_settings [Hash]

Returned

- disk_agent_settings [Hash]: Updated disk settings

```
{
	"system": "/dev/sda",
	"ephemeral": "/dev/sdb",
	"persistent": {
	    "vol-3475945": { "volume_id": "3" },
	}
}
```

# Modifications to agent_settings

- add SSL certificates and rootCA chain
- remove VM CID
- Director knows about different parts in agent_settings: disk_settings, network_settings,
- some parts of the agent_settings are only modified by the CPI and therefore never passed in, only returned: disk_settings, ???
- some parts are only modified by the director and therefore never returned from the CPI: cert&key settings,
- some parts are only passed from director to agent, without the CPI knowing about them: ntp settings, blobstore, env
