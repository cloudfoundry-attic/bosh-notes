- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related: https://github.com/cloudfoundry/bosh/issues/1943

# Summary

`max_in_flight` configuration should offer a way to roll updates across all availability zones at the same time.

# Motivation

Currently `max_in_flight` is limited to a single AZ. Especially during fresh deployments that may be a non-optimal strategy. It should be possible to configure `max_in_flight` to do updates within X number of AZs in parallel.

# Details

```
instance_groups:
- name: foo
  update: # <-- backwards compat
    ...
  plan:
    create:
      ...
    update: 
      ...
    delete: 
      ...
```

# Drawbacks

...

# Unresolved questions

- should there be create/update/delete section?
  - does create apply to new instances when scaling up
