# Backup for installed releases

Backup:
* regular snapshots (cron-like time-based notation)
* snapshots before new deployments
* manual snapshots possible

Restore:
* create snapshot (to have a point to jump back to)
* `monit stop` all data nodes to prevent election of a new leader when the master goes down
* `monit stop` the leader node
* Create disk from snapshot
* Attach disk to job and replace current disk (or copy contents, whatever is easier)
* `monit start` the leader node
* `monit start` all data nodes

## Command Workflow

Snapshot and restore commands work in the context of a deployment.

```bash
$ bosh take snapshot api_z1 0
...
Snapshot taken

$ bosh snapshots
+-------------------+--------------------------------------+---------------------------+-------+
| Job/index         | Snapshot CID                         | Created at                | Clean |
+-------------------+--------------------------------------+---------------------------+-------+
| redis_leader_z1/0 | fb2fce2f-bc73-4798-95fb-50c4acf3927e | 2015-11-11 12:25:25 +0000 | false |
| redis_leader_z1/0 | 390afcfe-f1d8-4488-b69b-6baf4b078b00 | 2015-11-11 12:37:31 +0000 | false |
| redis_leader_z1/0 | 25a67ba0-b1dd-41a1-a97e-66f9871d2ca5 | 2015-11-11 12:38:29 +0000 | false |
| redis_data_z1/0   | 35a67ba3-b1dd-41a1-a97e-66f9871d2ca5 | 2015-11-11 12:39:29 +0000 | false |
| redis_data_z1/1   | 35a67ba3-b1dd-41a1-a97e-66f9871d2ca5 | 2015-11-11 12:39:29 +0000 | false |
| redis_data_z1/2   | 45a67ba3-b1dd-41a1-a97e-66f9871d2ca5 | 2015-11-11 12:39:29 +0000 | false |
| redis_data_z1/3   | 55a67ba3-b1dd-41a1-a97e-66f9871d2ca5 | 2015-11-11 12:39:29 +0000 | false |
| redis_data_z1/4   | 65a67ba3-b1dd-41a1-a97e-66f9871d2ca5 | 2015-11-11 12:39:29 +0000 | false |
| redis_leader_z1/0 | 28e261a1-ee1b-49b0-b11a-ad3fbffe2d58 | 2015-11-11 13:50:01 +0000 | true  |
+-------------------+--------------------------------------+---------------------------+-------+

$ bosh stop redis_data_z1 0
...
$ bosh stop redis_data_z1 4

$ bosh stop redis_leader_z1 0
$ bosh restore snapshot redis_leader_z1/0 fb2fce2f-bc73-4798-95fb-50c4acf3927e

$ bosh start redis_leader_z1 0
$ bosh start redis_data_z1 0
...
$ bosh start redis_data_z1 4
# Master syncs its data to the data nodes
```

## Copy contents or replace disk?

pro copy:
* better if you have increased your disk size in the meantime
* ???

pro replace:
* is faster
* better if you have reduced your disk size in the meantime
* ???

## TBD
* Main challenge: Finding out which instance is 'leader' and which instances are 'data'. This is service-specific knowledge, so bosh probably can't help you here.
  * In which order should instances be brought down and then up again?
  * Which snapshot is the one you want to restore? If e.g. the `redis_leader_z1` went down at some point in time, one of the `redis_data_z1` nodes might have been elected leader. This should be the disk you want to restore a master node with!
* Annotations for snapshots? E.g. triggered manually, triggered before deploy, triggered by cron, triggered before restore.
* What about processes that keep a bunch of state in memory. Do we need to call the `drain` script before taking an IaaS snapshot? Currently this is only guaranteed for snapshots taken before a `bosh deploy`
* Are there services which need to call a script to import state written to disk by the `drain` script? Should this go into `pre_start` or is this something different?
* Snapshots are no backup, it's just a means to jump back in time! If your disk goes belly-up the snapshots are worthless. Can/should we trigger a real backup for that disk as well? (e.g. cinder `backup-create`)
* Are there services which need the replicas in a consistent state? Do we need something like consistent snapshots across VMs, as e.g. provided by `cinder cg-snapshot` which snapshots disks at the same time?

# Backup for the Director
tbd
