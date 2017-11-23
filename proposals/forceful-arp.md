- State: finished

# Forceful ARP

As new VM comes up, ARP entries (on AWS for example) on other VMs are not cleared.

Proposal: send explicit messages to all agents to flush ARP entries for specific IPs.

# Stories

- Investigate if arp -d is able to forcefully kill the connection while conn is in diff states

- Agent can flush ARP entries on request
  - asynchronous action
  - "flush_arp" action with one argument {"ips": ["10.10.0.2", ...]}
  - runs "arp -d" for each IP
  - support ubuntu and centos

- During `bosh deploy` when new VM comes up, send flush_arp request
  - make a configuration option (director.flush_arp=bool) and keep this disabled by default for now
  - find all VMs in *all* deployments and send flush_arp after Director finds out IPs for new machine
  - make sure to collect *all* new IPs

- During cck/ressurection when new VM comes up, send flush_arp
  - should be noop as it should go through VmCreator

# TBD

- Optimization to only send it to VMs within necessary subnet
