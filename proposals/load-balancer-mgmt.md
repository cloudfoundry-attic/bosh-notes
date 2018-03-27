- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Director should create, update, and delete load balancers dynamically so deployments can consume load balancers without relying on external tools.

# Motivation

Use cases:

- support mgmt of CF gorouter HTTP & TCP load balancers
- support mgmt of Concourse ATC load balancer
- support mgmt of Kubo API node load balancer

# Details

...

## IaaS specifics

- AWS
- Azure
- vSphere (F5 & NSX & NSX-T)
- OpenStack
- GCP
- Warden & Docker
- Nginx
- Gorouter
- Envoy?

# Drawbacks

...

# Unresolved questions

- management of certificates
- integration with third party (non-IaaS) load balancers
- floating ip creation?
- how does consuming job know about system entrypoint
