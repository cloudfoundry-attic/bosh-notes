- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Release job authors should be able to find out in their drain scripts whether instance is being updated, removed, deleted, etc.

# Motivation

Use cases:

- skip draining data when deployment is deleted
- export data out of cluster when deployment is deleted
- move data to a different node (if it's the only copy) when instance is deleted
- check that data is replicated elsewhere before instance (and its disk) is deleted
- do not move data to a different node when instance is deleted
- deregister etcd member when scaling down instance group
- drain kubelet (talks to master) during update, but not during delete

# Details

## Scenarios

Drain scripts are called in the following situations:
- During a deployment `bosh deploy`
  - When updating any job on the instance (includes removing a job)
  - When scaling down an instance
  - When deleting an instance group
  - When removing AZs
  - When the `--recreate` flag is used
  - When migrating from another instance group [to be investigated]
  - When a VM will become orphaned [to be investigated, see: create-swap-delete]
- During a `bosh stop`
- During a `bosh stop --hard`
- During a `bosh delete-vm`
- During a `bosh recreate`

The information exposed to the drain script will include:
- The expected (target) state for the instance. We can be in multiple states at the same time (eg. Deleted + Recreated)
  - Deleted (All the above scenarios except `bosh stop`)
  - Stopped (`bosh stop`)
  - Recreated (`--recreate` flag used on deploy, `bosh recreate`)
- The expected (target) state for the deployment
  - Deleted (`bosh delete-deployment`)
  - Updated (`bosh deploy`)
- The expected (target) state for the instance group
  - Scaled-down
  - Removed-AZ
  - Updated

## Proposed changes

Following environment variables should be passed into `bin/drain` script with modifications.

```
BOSH_JOB_STATE={persistent_disk: ...}
BOSH_JOB_NEXT_STATE={persistent_disk: ...}
```

possible job states: running, stopped, deleted

possible disk states: available, unavailable, deleted

- TBD: job vs instance?
- TBD: colocation of helper jobs: data-exporter?

# Drawbacks

...

# Unresolved questions

...
