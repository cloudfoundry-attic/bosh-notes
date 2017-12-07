- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Errands should be able to run before and/or after particular events during a `bosh deploy` execution.

# Motivation

Use cases:

- perform DB migration (cloud controller): run migration scripts before starting to update cloud controller instances
- deploy kube-dns (kubo): needs to run at the end of the deploy when kube cluster is up and running
- mysql (pivotal mysql v2): needs to run at the end of the deploy to select a master out of multiple undifferentiated instances

# Details

...

# Drawbacks

...

# Unresolved questions

...

# Related

- [job-ordering.md](job-ordering.md)
