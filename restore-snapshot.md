# Restore persistent disk from a snapshot

This document describes a procedure to recover the data of persistent disk from a snapshot previously created by Bosh.

## Goals

The restore procedure described in this document is targeted towards one main scenario: Restoring the persistent disk to a previous state which was snapshotted by Bosh, e.g. to roll back an update of a deployment which went horribly wrong and deleted data or changed a DB schema.

## Non-Goals

Snapshots are not meant for recovery in the case that the persistent disk is lost. Depending on the IaaS implementation, your snapshots might not even work without the persistent disk. Additionally, there is no guarantee that the storage location of the snapshot is different from that of the persistent disk. So if you e.g. lose a Cinder node in OpenStack, which stores your persistent disk, the snapshots might have been on the same Cinder node as well. Covering this case are not a goal of this proposal.

## Command Workflow

```bash
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

# optional: restore the same snapshot for all other nodes as well, if your service allows for it.
$ bosh restore snapshot redis_data_z1/0 fb2fce2f-bc73-4798-95fb-50c4acf3927e
$ bosh restore snapshot redis_data_z1/1 fb2fce2f-bc73-4798-95fb-50c4acf3927e
$ bosh restore snapshot redis_data_z1/2 fb2fce2f-bc73-4798-95fb-50c4acf3927e
$ bosh restore snapshot redis_data_z1/3 fb2fce2f-bc73-4798-95fb-50c4acf3927e
$ bosh restore snapshot redis_data_z1/4 fb2fce2f-bc73-4798-95fb-50c4acf3927e

$ bosh start redis_leader_z1 0
$ bosh start redis_data_z1 0
...
$ bosh start redis_data_z1 4
# Master syncs its data to the data nodes
```
