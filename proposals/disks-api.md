- State: discussing

# Disk API consistency WIP

```
GET /vms

GET /orphan_vms
{orphaned_at...}

DELETE /vms/:vm_cid
bosh delete-vm vm_cid
- delete VM permanently

DELETE /disks/:disk_cid
- error (cannot just delete)

DELETE /disks/:disk_cid?orphan=true
bosh orphan-disk disk_cid
- orphan disk from instance (db flip)

PUT /disks/:disk_cid/attachments?deployment=foo&job=dea&instance_id=17f01a35-bf9c-4949-bcf2-c07a95e4df33
bosh attach-disk instance disk_cid
- removed orphaned copy

GET /disks
bosh disks
{cid:...}
- list disks used by deployments

GET /orphan_disks
bosh disks --orphaned
{orphaned_at...}
- list orphaned disks

DELETE /orphan_disks/:cid
bosh delete-orphan-disk disk_cid
- deletes disk from iaas permanently
```
