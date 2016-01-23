## Multi CPI [PLANNING]

- upload stemcell changes
  - e.g. to determine which OpenStack tenant to use
  - upload stemcell uploads to all CPIs
    - CPI's info provides supported stemcell formats?
  - upload stemcell when necessary by keeping it in blobstore
    - dont have to reupload later if new CPIs added

- add cpi key to AZ

- add cpis section to cloud config
  - use type in CPI's info
  - use job specifiers?
    - isnt generic for remote CPIs?

- all cloud interactions should be in a context of an AZ and associated CPI config

Example:

```yaml
cpis:
- name: openstack-left
  type: openstack
  properties:
    auth_url: IDENTITY-API-ENDPOINT
    tenant: 1
    username: OPENSTACK-USERNAME
    api_key: OPENSTACK-PASSWORD
    default_key_name: bosh
    default_security_groups: [bosh]
- name: openstack-right
  type: openstack
  properties:
    auth_url: IDENTITY-API-ENDPOINT
    tenant: 2
    username: OPENSTACK-USERNAME
    api_key: OPENSTACK-PASSWORD
    default_key_name: bosh
    default_security_groups: [bosh]

azs:
- name: z1
  region: r1
  cpi: openstack-right
  cloud_properties: {...}
- name: z2
  region: r1
  cpi: openstack-right
  cloud_properties: {...}
- name: z3
  region: r2
  cpi: openstack-left
  cloud_properties: {...}
- name: z4
  region: r2
  cpi: openstack-left
  cloud_properties: {...}

jobs:
- name: gemfirer1
  azs: [z1, z2]

- name: gemfirer2
  azs: [z3, z4]

- name: gemfire
  azs: [z1, z2, z3, z4]
  # gemfire should form local cluster with z1&z2 if in z1|z2
  # gemfire should form local cluster with z3&z4 if in z3|z4
  # gemfire should form wan repl with z1&z2 if in z3|z4
  # gemfire should form wan repl with z3&z4 if in z1|z2

- name: web
  azs: [z1, z2, z3, z4]
  jobs:
  - name: web
    release: web
    consumes:
      gemfire: {from: gemfire}
  # web should talk to z1&z2 if in z1|z2
  # web should talk to z3&z4 if in z3|z4
```
