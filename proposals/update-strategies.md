- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related proposals: [max-in-flight-v2.md](https://github.com/cloudfoundry/bosh-notes/blob/master/proposals/max-in-flight-v2.md), [update-strategy-create.md (aka hotswap)](https://github.com/cloudfoundry/bosh-notes/blob/master/proposals/update-strategy-create.md), [update-strategy-scale-down.md](https://github.com/cloudfoundry/bosh-notes/blob/master/proposals/update-strategy-scale-down.md), [update-strategy-surge.md](https://github.com/cloudfoundry/bosh-notes/blob/master/proposals/update-strategy-surge.md)

# Summary

...

# Motivation

...

# Details

- `update.vm_strategy`
  - `legacy` -> `delete-create` - existing, previous behavior
  - `hot-swap` -> `create-swap-delete` - current hotswap track

- instance update (replacement of instances is not connected to scale up/down)
  - reuse existing instances
  - full instance replace (new instance info, new persistent disks)
    - at most num nodes running

- instance group update
  - scale up X%/num (implies that new instances are kept, and old instances are killed)
    - create new instances (and delete old instances at the end)
    - TBD: what max_in_flight is used for newly created instances?
  - scale down to X%/num and then create new instances? (etcd?)
  - [scale down to 0%] turn off all instances, then update (earlang)
    - applies to legacy, or hotswap
    - TBD: how do you deal with optional scale down to 0% since most of the update we are NOT updating earlang

# Drawbacks

...

# Unresolved questions

- total vms to have within a director or cpi?
