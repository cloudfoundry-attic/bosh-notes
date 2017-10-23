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
