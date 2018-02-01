- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Operator should be able to delete any instance from an instance group for whatever reason.

# Motivation

Use cases:

- remove "bad" instance to recover (something went wrong with combination VM and persistent disk)
- scale down manually by killing off particular data instance
  - instance is selected by the operator for some reason (may be due to data on it, may be due to its uuid)
  - examples: [logsearch](https://github.com/cloudfoundry-community/logsearch-boshrelease/blob/ee8467b4943968e58a07e1c05d9c20529ef5540f/docs/running_the_cluster.md#bulletproof-downgrade)
- to cause AZ rebalance for an instance group with persistent disks

# Details

We currently provide `delete-vm` and `orhan-disk` commands but we do not provide a way to get rid of a particular instance. Scaling down an instance group is potentially one way to delete instances from the end of the list, but it's very implicit.

```
$ bosh -d dep1 delete elasticsearch_data/b6b31012-84b0-4e47-8b55-a98d9c6e05e8
```

- called `delete` to follow start/stop/etc convention

After running this command, if manifest is unchanged it's expected that new instance is brought up via `bosh deploy`. Since instance is gone, HM will not be able to bring it back automatically.

# Drawbacks

...

# Unresolved questions

- should we allow deletion of an entire instance group, set of instances?
