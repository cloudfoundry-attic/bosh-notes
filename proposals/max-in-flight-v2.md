- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

`max_in_flight` configuration should offer a way to roll updates across all availability zones at the same time.

# Motivation

Currently `max_in_flight` is limited to a single AZ. Especially during fresh deployments that may be a non-optimal strategy. It should be possible to configure `max_in_flight` to do updates within X number of AZs in parallel.

# Details

...

# Drawbacks

...

# Unresolved questions

...
