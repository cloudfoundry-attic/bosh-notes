# Multiple Disks [PLANNING]

Wanted:

- multiple raw disks
- multiple partitioned/formatted disks
- different disk configurations (size and types)
- custom filesystem and options

---

Cloud config definition does not change:

```yaml
disk_types:
- name: 10gb
  disk_size: 10000
  cloud_properties:
    type: io1
    iops: 10000
```

```yaml
instance_groups:
- name: blha
  jobs:
  - name: postgres
    properties: {...}

  vm_type: name  # <-- right now
  vm:
    ram: 2
    cpu: 3
    ephemeral_disk_size: 10_000

  persistent_disk_type: 10gb   # <-- right now
  persistent_disk: 10_000  # <-- right now

  persistent_disks:
  - name: wal-files # => /var/vcap/store-wal-files, /dev/by-path/bosh-persistent-wal-files
    type: 10gb
    partition: true # <-- could be false for raw-disk
		fs:
      type: xfs # <-- default to ext4
      options: ["noatime"]
  - name: data-files # => /var/vcap/store-data-files
    type: 10gb
  - name: disk1
    type: 10gb
    count: 5
  - name: disk2
    type: 10gb
  - name: disk3
    type: 10gb

  disk_mounts:
  - type: raid:
    level: blah
  - type: nfs
  - type: iscsi
  - type: lvm

  env:
    persistent_disk_fs: xfs  # <--- gone, placed on persistent_disks
    persistent_disk_fs_opts: [...]
```

/dev/by-path/bosh-raw-ephemeral-1 -> /dev/ca
/dev/by-path/bosh-raw-ephemeral-2 -> /dev/cb
/dev/by-path/bosh-persistent-wal-files -> /dev/cd
