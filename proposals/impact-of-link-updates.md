- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

As an operator, I expect to see which deployments consume link that has been just updated.

# Motivation

Shared links allow you to share information accross deployments. A common scenario is, that you want to offer a service around CF in another deployment, e.g. a service broker or a dashboard. In the past you would need to share the configuration and password. Now with links you can just consume it. Unfortunately link updates are not automatically applied accross deployments, so when I update CF and add/remove NATS instances, or if I change the NATS password, I need to update all deployments consuming the link. Having a logic that shows me, which links change, and additionally, which deployments are using the link will help the operator understand which deployments need to be updated.

# Details

...

# Drawbacks

...

# Unresolved questions

...
