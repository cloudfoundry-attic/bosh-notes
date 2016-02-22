# Global Networking [FINISHED]

Networks found in cloud config can be shared by multiple deployments such that created VMs do not get assigned same IPs.

For manual networks:
- Director has to figure out which IPs are checked out vs which ones are not
- Some IaaSes might disallow assignment of the same IPs (e.g. AWS, OpenStack) but some do not (e.g. vSphere)

For dynamic networks:
- Nothing to do since the IaaS assigns available IPs

For VIP networks:
- IaaS will prevent assignment of same IPs to multiple VMs
- Director can possibly do a better job at tracking which IPs already used and give quick feedback without asking the IaaS

## Stories

[see `global-net` label in Tracker for created stories]

* user can deploy two deployments on a shared manual network and the Director picks next available IP for the second VM (8)
* user should see an error message if two deployments try to request same static IP
  - include name of the deployment that owns it
* user can deploy a VM with a static IP once it is released from a different deployment
  - so that to see static IPs are reused across deployments

## TBD

- moving static IPs
- reassigning IP from one deployment to another due to it changing its type (auto -> static)
