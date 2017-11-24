# Summary

## in-progress

- [links-api](proposals/links-api.md)
  - State: in-progress
  - Tracker label: links-api
  - Summary: Deployment links information should be exposed over an API.

- [registry-removal](proposals/registry-removal.md)
  - State: in-progress
  - Summary: BOSH currently contains Registry component which it technically does not need.

- [resurrection-config](proposals/resurrection-config.md)
  - State: in-progress
  - Summary: HM should allow much more granular configuration for which deployments/jobs/instance groups should be resurrected.

- [tasks-config](proposals/tasks-config.md)
  - State: in-progress
  - Summary: There needs to be a way to configure Director to rate limit, prioritize etc task executions so that tasks could be executed in a manner acceptance to the operators.

- [to-be-deprecated](proposals/to-be-deprecated.md)
  - State: in-progress
  - Summary: Tracking user features and specific code that needs to be deprecated. Permanently `in-progress`.

- [ubuntu-xenial-stemcells](proposals/ubuntu-xenial-stemcells.md)
  - State: in-progress
  - Start date: 10/23/2017
  - End date: ?
  - Summary: BOSH should provide Ubuntu Xenial stemcells for the community.

- [update-strategy-create](proposals/update-strategy-create.md)
  - State: in-progress
  - Start date: 11/12/2017
  - End date: ?
  - Docs: ?
  - Summary: BOSH should allow alternative instance update strategy that would reduce process downtime, helping significantly singleton processes.

## discussing

- [blob-tracking](proposals/blob-tracking.md)
  - State: discussing

- [brokered-link](proposals/brokered-link.md)
  - State: discussing

- [certificate-ca-rotation](proposals/certificate-ca-rotation.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Summary: It should be possible to rotate CA certificates with the help of config server API without incurring any downtime.

- [computed-links](proposals/computed-links.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Summary: It should be possible for a job to control contents of a provided link via an ERB template.

- [cpi-api-v2](proposals/cpi-api-v2.md)
  - State: discussing

- [cpi-cleanup](proposals/cpi-cleanup.md)
  - State: discussing

- [cpi-resource-uniqueness](proposals/cpi-resource-uniqueness.md)
  - State: discussing

- [deployment-steps](proposals/deployment-steps.md)
  - State: discussing

- [disks-api](proposals/disks-api.md)
  - State: discussing

- [generic-resources](proposals/generic-resources.md)
  - State: discussing

- [granular-instance-updates](proposals/granular-instance-updates.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Summary: It should be possible for the operator to update particular instance or group of instances within a deployment without affecting any other instances.

- [job-health-checks](proposals/job-health-checks.md)
  - State: discussing

- [job-lifecycle](proposals/job-lifecycle.md)
  - State: discussing

- [k8s-cloud-provider](proposals/k8s-cloud-provider.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: Director (and an additional component) should provide APIs to fulfill typical Kubernetes cloud provider to manage persistent disks, load balancers, and networks.

- [load-balancer-mgmt](proposals/load-balancer-mgmt.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: Director should create, update, and delete load balancers dynamically so deployments can consume load balancers without relying on external tools.

- [manifest-strictness](proposals/manifest-strictness.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: Director should validate and raise errors when unknown/incorrect keys are specified in configs and deployment manifests.

- [network-mgmt](proposals/network-mgmt.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: Director should create, update, and delete networks dynamically so deployments can be assigned dedicated networks.

- [ops-file-requests](proposals/ops-file-requests.md)
  - State: discussing

- [os-reload](proposals/os-reload.md)
  - State: discussing

- [property-validation](proposals/property-validation.md)
  - State: discussing

- [restore-snapshot](proposals/restore-snapshot.md)
  - State: discussing

- [security-group-mgmt](proposals/security-group-mgmt.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: Director should create, update, assign and delete security groups dynamically so that instances are automatically configured with them.

- [snapshots](proposals/snapshots.md)
  - State: discussing

## finished

- [addons](proposals/addons.md)
  - State: finished
  - Docs: http://bosh.io/docs/runtime-config#addons

- [asset-fetching](proposals/asset-fetching.md)
  - State: finished

- [availability-zones](proposals/availability-zones.md)
  - State: finished
  - Docs: http://bosh.io/docs/azs

- [cli-deployment-resources](proposals/cli-deployment-resources.md)
  - State: finished

- [cloud-config](proposals/cloud-config.md)
  - State: finished
  - Docs: http://bosh.io/docs/cloud-config

- [compiled-releases](proposals/compiled-releases.md)
  - State: finished
  - Docs: http://bosh.io/docs/compiled-releases

- [config-server](proposals/config-server.md)
  - State: finished

- [configs-api](proposals/configs-api.md)
  - State: finished

- [deployment-naming](proposals/deployment-naming.md)
  - State: finished

- [dynamic-provisioning](proposals/dynamic-provisioning.md)
  - State: finished

- [errands-v2](proposals/errands-v2.md)
  - State: finished
  - Docs: http://bosh.io/docs/errands

- [events](proposals/events.md)
  - State: finished
  - Docs: http://bosh.io/docs/events

- [forceful-arp](proposals/forceful-arp.md)
  - State: finished

- [global-networking](proposals/global-networking.md)
  - State: finished
  - Docs: http://bosh.io/docs/networks

- [links](proposals/links.md)
  - State: finished

- [multi-cpi](proposals/multi-cpi.md)
  - State: finished
  - Docs: http://bosh.io/docs/cpi-config

- [multiple-disks](proposals/multiple-disks.md)
  - State: finished

- [persistent-disk-mgmt](proposals/persistent-disk-mgmt.md)
  - State: finished
  - Docs: http://bosh.io/docs/persistent-disks

- [release-creation](proposals/release-creation.md)
  - State: finished

- [security-groups-in-resource-pools](proposals/security-groups-in-resource-pools.md)
  - State: finished

- [uaa](proposals/uaa.md)
  - State: finished
  - Docs: http://bosh.io/docs/director-users-uaa

## rejected

- [director-config](proposals/director-config.md)
  - State: rejected
  - Reason: currently existing configuration facilities provide enough functionality

