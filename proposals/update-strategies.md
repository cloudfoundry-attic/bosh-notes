- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related proposals: [max-in-flight-v2.md](https://github.com/cloudfoundry/bosh-notes/blob/master/proposals/max-in-flight-v2.md)

# Summary

...

# Motivation

...

# Details

- vm update
  - `legacy` -> `in-place-replace-vm` - existing, previous behavior
  - `hot-swap` -> `duplicate-and-replace-vm` - current hot swap track

- instance update (replacement of instances is not connected to scale up/down)
  - reuse existing instances
  - full instance replace (new instance info, new persistent disks)
    - at most num nodes running

- instance group update
  - scale up X%/num
    - create new instances (and delete old instances at the end)
  - scale down to X%/num and then create new instances? (etcd?)
  - [scale down to 0%] turn off all instances, then update (earlang)
    - applies to legacy, or hotswap
    - TBD: how do you deal with optional scale down to 0% since most of the update we are NOT updating earlang

# Drawbacks

...

# Unresolved questions

- total vms to have within a director or cpi?
