# Security Groups on resource pools instead of networks
Allows having machines in the same network, but with different incoming/outgoing rules. Example: only the runners/DEAs of a CF deployment should be able to access some service VMs in a different network.

Right now, security group configuration work on the `network` property. To have two jobs in the same network but with different security groups, you'd have to define two networks, like this:

```yaml
networks:
- name: my_network_with_service_access
  type: manual
  subnets:
  - range: 10.10.0.0/24
    gateway: 10.10.0.1
    cloud_properties:
      net_id: net-b98ab66e-6fae-4c6a-81af-566e630d21d1
      security_groups: [cf,access-to-services-sec-group]
- name: my_network_without_service_access
  type: manual
  subnets:
  - range: 10.10.0.0/24
    gateway: 10.10.0.1
    cloud_properties:
      net_id: net-b98ab66e-6fae-4c6a-81af-566e630d21d1
      security_groups: [cf]
```

And networks are referenced by jobs:

```yaml
jobs:
- name: runner_z1
  resource_pool: runner_pool_z1
...
  networks:
  - name: my_network_with_service_access
    static_ips: [10.10.0.2]
    default: [dns, gateway]
jobs:
- name: etcd_z1
  resource_pool: etcd_pool_z1
...
  networks:
  - name: my_network_without_service_access
    static_ips: [10.10.0.3]
    default: [dns, gateway]
```

Moving security groups to the `resource_pool` property would allow for setting this up with only one network defined

```yaml
resource_pools:
  - name: runner_pool_z1
    cloud_properties:
      ...
      security_groups: [cf,access-to-services-sec-group]
resource_pools:
  - name: etcd_pool_z1
    cloud_properties:
      ...
      security_groups: [cf]
networks:
- name: my_network
  type: manual
  subnets:
  - range: 10.10.0.0/24
    gateway: 10.10.0.1
    cloud_properties:
      net_id: net-b98ab66e-6fae-4c6a-81af-566e630d21d1
```

And jobs would reference different resource pools, but the same network

```yaml
jobs:
- name: runner_z1
  resource_pool: runner_pool_z1
...
  networks:
  - name: my_network
    static_ips: [10.10.0.2]
    default: [dns, gateway]
jobs:
- name: etcd_z1
  resource_pool: etcd_pool_z1
...
  networks:
  - name: my_network
    static_ips: [10.10.0.3]
    default: [dns, gateway]
```

# Stories
- user can specify `security_groups` array in `resource_pool.cloud_properties` (4)
	- if security_groups are in networks and resource_pools, blow up
	- security_groups from resource_pool are used during create_vm, if specified
	- old manifests should continue to work: if there are no security_groups on the resource_pool, get them from the network
  - don't change anything in regards to default security groups
- user can update vm network settings, and security_groups stay the same on the vm (2)
  - `configure_networks` currently checks if security groups have changed compared to the current VM configuration
  - introduce new configuration property for the CPI to use security groups on resource_pools.
  - if new property is set, don't diff the security groups on `configure_networks`
- exploration: how often is `configure_networks` even done?
  - The only use-case seems to be to change Floating IP attachment. Can we afford just to drop support for re-configuring Floating IPs on running VMs and just have them re-created instead?
