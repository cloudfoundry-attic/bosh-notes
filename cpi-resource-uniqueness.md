# CPI Resource Uniqueness

We've run into several cases when CPIs were not able to create unique resources based on resourece names because IaaS did not enforce naming uniquness.

Examples:

- OpenStack
  - Server groups (policy with anti affinity) -- uniqueness is only done for IDs
  - Security groups

- vSphere
  - Security groups
