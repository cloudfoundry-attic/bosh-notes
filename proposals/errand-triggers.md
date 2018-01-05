- State: discussing
- Start date: ?
- End date: ?
- Related proposals: [job-ordering.md](job-ordering.md)
- Related issues: [Issue #1688](https://github.com/cloudfoundry/bosh/issues/1688)
- Related slacks: [link 1](https://cloudfoundry.slack.com/archives/C02HPPYQ2/p1515193109000126)
- Docs: ?

# Summary

Errands should be able to run before and/or after particular events during a `bosh deploy` execution.

# Motivation

Use cases:

- perform DB migration (cloud controller): run migration scripts before starting to update cloud controller instances
- deploy kube-dns (kubo): needs to run at the end of the deploy when kube cluster is up and running
- mysql (pivotal mysql v2): needs to run at the end of the deploy to select a master out of multiple undifferentiated instances
- elasticsearch: "their docs recommend to change some runtime config before starting a rolling update (and undo them once done)"

# Details

...

# Drawbacks

...

# Unresolved questions

- operator vs release author configuration
