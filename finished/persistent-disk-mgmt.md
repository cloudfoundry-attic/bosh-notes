# Persistent Disk Management (Orphaned Disks, etc.) [FINISHED]

Currently persistent disks are deleted upon instance deletion which happens when deployment jobs are scaled down, completely removed from the manifest or deployment is deleted. In all of these cases (may except deployment deletion) it's very easy to accidently delete the persistent data. Additionally we are adding a feature that would allow deployment job rename and merge to migrate users to new AZ functionality, and this feature may also trigger instance deletion during a migration. To avoid accidental data loss we want to avoid immediately deleting persistent disks on instance deletion. Instead the Director will keep the disks and provide means to re-attach them to existing Instances. Disks which are no longer needed will eventually be garbage collected.

## Workflow

```
$ bosh deploy

# Shows the diff showing that job will be deleted
```

Deploy command will no longer delete persistent disks but rather mark them orphaned. Disks should be marked as orphaned when:

- instance is deleted (job is scaled down, job is removed)
- disks are resized
- deployment is deleted

```
$ bosh disks --orphaned

+------------+------+------------+-----------+-------------------------+
| Disk CID   | Size | Deployment | Instance  | Orphaned At             |
+------------+------+------------+-----------+-------------------------+
| vol-dc248a | 10gb | cf         | api/dhbtf | 2015-09-29 23:46:58 UTC |
| vol-dc239a |  5gb | concourse  | api/dhbtf | 2015-09-29 23:46:54 UTC |
+------------+------+------------+-----------+-------------------------+
```

Listing orphaned disks does not happen within a context of a deployment. Deleting a deployment should not affect orphaned disks in any way i.e. user can still see deployment and instance names. Orphaned disks are kept at the Director level. Only Administrators can list orphaned disks.

See [CLI deployment resources](cli-deployment-resources.md#disks) for a basic disks command.

```
$ bosh attach disk api/dhbtf vol-dc248a
```

Attach disk command allows to reattach any disk (orphaned and known to the Director or coming from the IaaS) to an instance in a current deployment. If instance has a disk attached, that disk will be orphaned. Only Administrators can attach orphaned disks.

```
$ bosh delete disk vol-dc248a
```

Delete disk command works at the Director level. It will only allow to delete orphaned disks. Only Administrators can delete orphaned disks.

```
$ bosh cleanup --all
```

Cleanup command should remove all orphaned disks that belong to deployments that do not exist. Command should not remove disks that are being orphaned as it runs. Do deletion of disks in parallel. Only Administrators can clean up orphaned disks.

The Director will garbage collect orphaned disks after 5 days by default (configuration option).

## Stories

[labeled with `orph-disks`]

## TBD

- sorting (most recent at the top regardless of deployment/instance)
- pagination?
- filtering based on instance/deployment/time?
- can be disabled so orphaned disks will cleaned up very timely (~minutes instead of days)
- when attaching a disk to an instance raise an error if instance is not meant to have a persistent disks?
