# Disk API consistency WIP

GET /vms

GET /orphan_vms
{orphaned_at...}

DELETE /vms/:vm_cid
bosh delete-vm vm_cid
- delete VM permanently

DELETE /disks/:disk_cid -> error (cannot just delete)
DELETE /disks/:disk_cid?orphan=true -> orphans persistent disk?
bosh orphan-disk disk_cid
- orphan disk from instance (db flip)

PUT /disks/:disk_cid/attachments?deployment=foo&job=dea&instance_id=17f01a35-bf9c-4949-bcf2-c07a95e4df33
bosh attach-disk instance disk_cid
- removed orphaned copy

bosh disks
GET /disks
{cid:...}
- list disks used by deployments

bosh disks --orphaned
GET /orphaned_disks
{orphaned_at}
- list orphaned disks

DELETE /orphan_disks/:cid
bosh delete-orphaned-disk disk_cid
- deletes disk from iaas
