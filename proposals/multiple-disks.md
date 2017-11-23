- State: finished

# Multiple Disks

Wanted:

- multiple raw disks
- multiple partitioned/formatted disks
- different disk configurations (size and types)
- custom filesystem and options

---

Cloud config definition does not change:

```yaml
disk_types:
- name: 100gb
  disk_size: 10000
  cloud_properties:
    type: io1
    iops: 10000
```

Deployment manifest has a new configuration to specify multiple persistent disks:

```yaml
instance_groups:
- name: postgres
  instances: 3

  jobs:
  - name: postgres
    release: postgres
    properties: {...}
    consumes:
      data_files: {from: data-files}
      wal_files: {from: wal-files}
  - name: postgres-split-disk-setup               # internally uses xfs or raid or whatever
    release: postgres
    consume:
      wal-files-disk: {from: wal-files-disk}
      data-files-disk: {from: wal-files-disk}
    provides:
      data_files: {as: data-files}                # provides type=mount link
      wal_files: {as: wal-files}                  # provides type=mount link
  - name: xfs                                     # bring in necessary dependencies via packages
    release: fs-tools
  - name: raid
    release: fs-tools
  - name: efs
    release: fs-tools
    properties:
      fs_id: fs-0357964a

  persistent_disks:
  - name: data-files-disk                         # provides type=disk link
    type: 400gb
  - name: wal-files-disk                          # provides type=disk link
    type: 100gb
```

## Stories

- allow user to specify multiple persistent disks on an instance group
  - just does the CPI (doesnt call agent mount_disk)
  - uses appropriate disk type (v1 and v2)
  - ensures that names are unique within instance group

- user can add/delete disks from the instance group
  - "diff" disks by name
  - orphan disks as usual

- director makes type=disk links available for each disk for each instance
  - user should be to write a release to consume disk links
  - put name of the disk into the link

- user can find out disk path from disk name
  - depend on /var/vcap/instance/disks/<name> symlink that agent writes out
    - possible change mount_disk call to record symlinks (dont format)

(able to write release that partitions/formats/mounts and exposes type=mount)

- user can see that disk path cannot be resolved from disk name because symlink has been removed

- investigate what happens after reboot...

<mvp?>

- user can start/stop/run_scripts/drain/etc specific set of jobs on the vm (via agent api)
  - add filtering to api calls
  - backwards compatible

- release author doesnt have to wait in jobs for mounts to appear
  - director should pre-start/start/post-start disk jobs before other jobs
  - any jobs that provide type=mount links are considered disk jobs

- release author doesnt have to wait in jobs for network to appear
  - director should pre-start/start/post-start disk jobs before other jobs
  - any jobs that provide type=network links are considered network jobs

- release author can safely run drain/stop operations without worrying about network/disk
  - because director should stop generic-jobs, then disk jobs, then network jobs

- release author can give exported link property custom name to maintain nice link interface
  - e.g. `- {name: listen_port, as: port}`
