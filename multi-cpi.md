## Multi CPI [PLANNING]

Certain environments require use of multiple IaaSes. These IaaSes may be of the same type or not (two separate OpenStack installations for example vs AWS and vSphere). Assuming that proper networking is configured and the Director can reach VMs in necessary IaaS networks once they are created, the Director should be able to manage IaaS resources across IaaSes.

Following items are out of scope for this initial proposal:

- dealing with unreachable VMs due to network topology
- changing all CPIs to support basic workflow
- adding clustered Director support (separate work item)
- making a stemcell that works on all IaaSes

## Basic workflow

```
$ bosh-init deploy director.yml
```

- ensures that openstack_cpi, aws_cpi is colocated with the director/workers
  - could configure openstack CPI with dummy information to avoid adding more work to the first PR /cc Marco from SAP
- will not eventually configure cpi at deploy time
- now director is running...

```
$ cat cpi.yml

cpis:
- name: openstack-left
  type: openstack
  properties:
    auth_url: https://...
    tenant: left
    username: ((openstack-left-user))
    api_key: ((openstack-left-pass))
    default_key_name: bosh
    default_security_groups: [bosh]
- name: openstack-right
  type: openstack
  properties:
    auth_url: https://...
    tenant: right
    username: ((openstack-left-user))
    api_key: ((openstack-left-pass))
    default_key_name: bosh
    default_security_groups: [bosh]
#...

$ bosh update cpi-config cpi.yml
```

- add a new table
- CPI config isn't versioned like cloud config so that credentials etc could be updated at any time
- will work with config-server API to store creds once we implement for cloud config
- info method for CPIs

```
$ cat cloud.yml

azs:
- name: z1
  cpi: openstack-right # <----------- new optional key
  cloud_properties: {...}
- name: z2
  cpi: openstack-right
  cloud_properties: {...}
- name: z3
  cpi: openstack-eu
  cloud_properties: {...}

vm_types:
- name: left-n-right-vm
  cloud_properties:
    instance_type: medium

vm_extensions:
- name: left-n-right-ext
  cloud_properties:
    security_groups: [left-n-right]

disk_types:
- name: left-n-right-disk
  cloud_properties:
    type: ssd
#...

$ bosh update cloud-config cloud.yml
```

- add optional `cpi` key to each AZ
  - defaults to nil indicating to use deafult CPI
- assumes for now that VM types, disk types and VM extensions just work across CPIs

```
$ bosh upload stemcell ~/.tgz
```

- pick CPIs that match stemcell format
  - CPIs need to add `info` CPI method to return supported stemcell formats /cc Marco from SAP
  - eventually will return CPI release version, nice!
- add `cpi` column to stemcells table
  - change uniqueness constraint from name+version to name+version+cpi
  - default value for cpi column is NULL
    - backwards compatible
  - `bosh upload stemcell .tgz --fix` should continue work and replace stemcell for all matching CPIs

```
$ cat manifest.yml

instance_groups:
- name: web
  azs: [z1, z2, z3]
  jobs:
  - name: web
    release: web
  vm_type: left-n-right-vm
  vm_extensions: [left-n-right-ext]
  disk_type: left-n-right-disk
#...

$ bosh deploy
```

- for now assume that VM type, disk type and VM extensions just work across CPIs
  - of course no gurantees
- start sending in associated CPI properties (defined in cpis.yml) to CPI at the time of the call
  - CPI should be able to accept properties in context key and use them instead of its job properties /cc Marco from SAP
  - see context key in https://bosh.io/docs/build-cpi.html#request
- propose to have DeploymentPLan::Instance not expose stemcell
  - .. so that it only exposes `stemcell_cid` that internally looks at correct stemcell model based on instance AZ... eg

      def stemcell_cid
        @stemcell.cid_for_az(az)
      end

  - (https://github.com/cloudfoundry/bosh/blob/master/bosh-director/lib/bosh/director/vm_creator.rb)

- compilation lock should use "#{os-name/verson}-#{package.id}" instead of "stemcell.id-package.id" key
  - since there is no need to compile packages again for each "same" stemcell
- make sure debug log doesnt print out CPI properties in "External CPI request..."

```
$ bosh delete vm vm-cid
```

- try all cpis if vm not found error is raised

## Picking CPI(s) to call...

Following assumes:
- CPIs add 'info' CPI call
- each AZ is associated with one CPI (each CPI could be used by multiple AZs)
- Director is still configured with a default CPI

- Stemcell management
  - create_stemcell: pick CPIs based on supported stemcell format
  - delete_stemcell: pick CPI based on saved cpi name in the stemcells table

- VM management
  - create_vm: pick CPI based on instance's AZ; pick default if there is AZ=nil
  - delete_vm: (same as above)
  - has_vm: (same as above)
  - reboot_vm: (same as above)
  - set_vm_metadata: (same as above)
  - configure_networks: (removed)

- Disk management
  - create_disk: pick CPI based on instance's AZ; pick default CPI if there is AZ=nil
  - delete_disk: pick CPI based on instance's AZ; for orphaned disks pick CPI based on saved AZ, if CPI returns disk is found, try all other CPIs
  - has_disk: pick CPI based on instance's AZ
  - attach_disk: (same as above)
  - detach_disk: (same as above)
  - get_disks: (same as above)

- Disk snapshots
  - snapshot_disk: pick CPI based on associated disk's instances's AZ; pick default CPI if AZ=nil
  - delete_snapshot: pick CPI based on associated disk's AZ; for orphaned snapshots pick CPI based on saved AZ on orphan disk, if CPI returns disk not found, try all other CPIs

- Misc
  - info: all CPIs should be called; if CPI returns unknown method, ignore it
  - current_vm_id: pick default CPI

## TBD

- how to rename CPIs given that stemcell save off their name? wont support currently?
- how to section off VM type, disk type, VM extensions based on CPI
  - same as we did for networking? -- AZ idenitifier with each cloud properties?
- disallow deafult CPI configuration?
