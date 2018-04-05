- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Director (and an additional component) should provide APIs to fulfill typical Kubernetes cloud provider to manage persistent disks (CSI), load balancers, networks, and VMs (cluster API).

# Motivation

...

# Details

...

# Drawbacks

- API is provided by the Director, so if Director is not available then Kube calls will be in queued state.

# Unresolved questions

...
