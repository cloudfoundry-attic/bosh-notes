- State: in-progress

# Registry removal

## CPI updates

API version 2 of CPIs will differ from version 1 by the following:

- `create_vm` will return disks configuration in addition to returning VM CID
  - `{"system": ..., "ephemeral": ...}`

- `attach_disk` will accept disks configuration in addition to VM CID and disk CID
  - `detach_disk` does not change since it should be able to determine disk by disk CID

- `attach_disk` will return disk hint as its result

## Director updates

- should have initially returned list of disks from `create_vm`

- should keep track of attached persistent disks (their hints) from `attach_disk` CPI call
  - updates `persistent` portion of disks configuration
  - calls `mount_disk` Agent method with disk hint for that disk

- should keep track of detached persistent disks from `detach_disk` CPI call
	- calls `unmount_disk` Agent method exactly the same way

## Sample API Calls

```
# a new vm gets created (v2 is now disk hints)
$ create_vm(...)
["vm-32r7834yt834", {"system": "/dev/sda", "ephemeral": "/dev/sdb"}]

# in the case where we need a new IaaS disk (same as before)
$ create_disk(...)
"disk-39748564"

# request the cpi attaches a disk and give director a hint about where the the disk is mounted
$ attach_disk("vm-32r7834yt834", "disk-39748564", {"system": "/dev/sda", "ephemeral": "/dev/sdb"}]
"/dev/sdc"
# now we director knows the hint about where the disk is mounted (contract between agent + cpi)
# director will be sure to record the hint for future operations

  # internally, we'll then call agent's mount_disk with the hint
  # "find disk-39748564 which should be mounted at /dev/sdc"
  agent$ mount_disk("disk-39748564", "/dev/sdc")

# attaching a (another) disk (future-ish for multiple persistent disk support)
# cpi is able to see current list of disks in case it needs to calculate what the next device should be
$ attach_disk("vm-32r7834yt834", "disk-54367", {"system": "/dev/sda", "ephemeral": "/dev/sdb", "persistent": {"disk-39748564": "/dev/sdc"}})
"/dev/sdd"
```
