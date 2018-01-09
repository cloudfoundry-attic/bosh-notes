# Summary

## in-progress

- [links-api](proposals/links-api.md)
  - State: in-progress
  - Tracker: https://www.pivotaltracker.com/n/projects/2132440
  - Tracker label: links-api
  - Track anchors: slack: @asu @dwick
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
  - Tracker: https://www.pivotaltracker.com/n/projects/2132441
  - Tracker label: hotswap
  - Track anchors: slack: @dzhao @rdayreynolds
  - Docs: ?
  - Summary: BOSH should allow alternative instance update strategy that would reduce process downtime, helping significantly singleton processes.

## discussing

- [api-pagination](proposals/api-pagination.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: API should allow pagination for expensive/lengthy resources. Pagination should account for concurrent deletions made during listing, hence have to use some kind of cursor mechanics.Pagination should not introduce breaking change to the API response.

- [auto-deploy-logs](proposals/auto-deploy-logs.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: User should see automatically selected logs for certain types of deploy failures so that it's easier to debug the problem.

- [az-retry](proposals/az-retry.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: In a multi-AZ setup, BOSH should distribute the instances of an AZ to other AZs, in case an AZ fails completely.

- [bbr-sdk](proposals/bbr-sdk.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: BOSH should take advantage of latest BBR SDK to support backing up remote DBs and blobstores.

- [blob-tracking](proposals/blob-tracking.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Related proposals: [proposals/instance-logs.md](proposals/instance-logs.md)
  - Summary: Director should track various blobs in one way and potentially expose it via consolidated API.

- [bosh-bpm](proposals/bosh-bpm.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: BOSH release should use bpm to wrap jobs for cleanliness and improved security.

- [bosh-dns-cert-sans](proposals/bosh-dns-cert-sans.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: BOSH Director should automatically configure certificates with correct SANs.

- [bosh-dns-job-pointer](proposals/bosh-dns-job-pointer.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: BOSH DNS should use job destinations (instead of instance group destinations) in its DNS addresses.

- [bosh-ha-nats](proposals/bosh-ha-nats.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: BOSH Agent should be able to connect to multiple NATS servers to support IPv4+IPv6 configurations, NATS server movement within a network, and failover.

- [bosh-recreate-disks](proposals/bosh-recreate-disks.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: User should be able to force to migrate persistent disks so that BOSH creates new disks in the IaaS.

- [brokered-link](proposals/brokered-link.md)
  - State: discussing

- [certificate-ca-rotation](proposals/certificate-ca-rotation.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: It should be possible to rotate CA certificates with the help of config server API without incurring any downtime.

- [cli-v2-windows](proposals/cli-v2-windows.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: CLI v2 should support Windows for release mgmt and Director operations (such as ssh and scp).

- [computed-links](proposals/computed-links.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Summary: It should be possible for a job to control contents of a provided link via an ERB template.

- [configs-api-v2](proposals/configs-api-v2.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Related proposals: [proposals/configs-api-v2-alt.md](proposals/configs-api-v2-alt.md)
  - Summary: CLI should provide a way to find different versions of configs stored in the Director.

- [configs-api-v2-alt1](proposals/configs-api-v2-alt1.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Related proposals: [proposals/configs-api-v2.md](proposals/configs-api-v2.md)
  - Summary: CLI should provide a way to find different versions of configs stored in the Director.

- [cpi-api-v2](proposals/cpi-api-v2.md)
  - State: discussing

- [cpi-cleanup](proposals/cpi-cleanup.md)
  - State: discussing

- [cpi-method-validate-configuration](proposals/cpi-method-validate-configuration.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: BOSH should be able ask CPIs if their configuration (IaaS creds, connectivity, etc.) is valid. 

- [cpi-resource-uniqueness](proposals/cpi-resource-uniqueness.md)
  - State: discussing

- [deployment-steps](proposals/deployment-steps.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: ...

- [diff](proposals/diff.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: Users should be able to view full diff of their changes without affecting currently running system. Diff should include details such as VM, disk recreation, new versions of releases, etc.

- [disks-api](proposals/disks-api.md)
  - State: discussing

- [drain-actions](proposals/drain-actions.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: Job authors should be able to find out in their drain scripts whether instance is being updated, removed, deleted, etc.

- [errand-triggers](proposals/errand-triggers.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Related proposals: [job-ordering.md](job-ordering.md)
  - Related issues: [Issue #1688](https://github.com/cloudfoundry/bosh/issues/1688)
  - Related slacks: [link 1](https://cloudfoundry.slack.com/archives/C02HPPYQ2/p1515193109000126)
  - Docs: ?
  - Summary: Errands should be able to run before and/or after particular events during a `bosh deploy` execution.

- [generic-resources](proposals/generic-resources.md)
  - State: discussing

- [granular-instance-updates](proposals/granular-instance-updates.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Summary: It should be possible for the operator to update particular instance or group of instances within a deployment without affecting any other instances.

- [instance-logs](proposals/instance-logs.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Related proposals: [proposals/blob-tracking.md](proposals/blob-tracking.md)
  - Summary: Director should record instance logs before terminating instances and provide a way for users to download these logs at a later time.

- [job-health-checks](proposals/job-health-checks.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: Release authors should be able to specify structured health checks to indicate whether job is healthy or unhealthy.

- [job-lifecycle](proposals/job-lifecycle.md)
  - State: discussing

- [job-ordering](proposals/job-ordering.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Related proposals: [errand-triggers.md](errand-triggers.md)
  - Docs: ?
  - Summary: User should be able to describe job order (startup, shutdown, etc.) within a single VM and across a deployment.

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

- [max-in-flight-v2](proposals/max-in-flight-v2.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: `max_in_flight` configuration should offer a way to roll updates across all availability zones at the same time.

- [namespaced-jobs-and-packages](proposals/namespaced-jobs-and-packages.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: BOSH should allow jobs and packages with the same name coexist on the same VM.

- [network-mgmt](proposals/network-mgmt.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: Director should create, update, and delete networks dynamically so deployments can be assigned dedicated networks.

- [openstack-director-az-to-multiple-iaas-azs](proposals/openstack-director-az-to-multiple-iaas-azs.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: OpenStack CPI should respect multiple `availability_zones` when creating VMs.

- [ops-file-requests](proposals/ops-file-requests.md)
  - State: discussing

- [os-reload](proposals/os-reload.md)
  - State: discussing

- [property-validation](proposals/property-validation.md)
  - State: discussing

- [quick-power-off](proposals/quick-power-off.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: BOSH should be able to stop (power off) and then start (power on) deployments quickly.

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

- [team-scoped-configs](proposals/team-scoped-configs.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: BOSH teams should be able to set their own set of configs (cloud, runtime, etc.) in addition to picking up global configs, so that they can customize their environment.

- [unmanaged-disks-resizing](proposals/unmanaged-disks-resizing.md)
  - State: discussing
  - Start date: ?
  - End date: ?
  - Docs: ?
  - Summary: User should be able to request to size for unmanaged disks in the manifests and BOSH should be able to migrate contents, though without expanding partitions.

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
  - Followup proposals: [proposals/configs-api-v2.md](proposals/configs-api-v2.md)

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

