- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

As a Director user, I expect to be able to get automatically assigned VIP (floating, elastic IPs) for each instance if I just assign VIP network to an instance group.

# Motivation

For software to be exposed externally, sometimes it's necessary to attach VIPs to instance groups. Currently you can attach them by explicitly specifying `static_ips` on an instance group (on a network attachment configuraiton). This method does not work well in an environment where VIPs have to be assigned dynamically and potentially without knowledge of an end user (for example for deployments created by ODB).

Our goal is to add functionality similar to manual network for VIPs, so that Director can manage them individually and assign available IPs to requesting instances.

# Details

Goals:

- reuse VIPs when possible for the same instance
- support AZ specific VIPs to support multi-CPI scenario
- support automatic provisioning and deprovisioning of VIPs
  - TBD: when is it ok to deprovision

# Drawbacks

...

# Unresolved questions

...
