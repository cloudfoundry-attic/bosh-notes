
## Default deployment manifest in release

If release provide default manifest which can be use to deploy the release as set of associated plans with-in the default manifest in release.

Sample manifest:

```
name: ((dynamic-based-on-deployment-name-from-director))
releases:
- name: foo-bar
  version: latest

instance_groups:
- name: mysql
  azs:
  - z1
  instances: 1
  jobs:
  - name: job-2
    release: foo-bar
  - name: job-1
    release: foo-bar

properties:
  admin_user: bannana
  admin_password: ((admin-password))

variables:
- name: admin-password
  type: password

stemcells:
- alias: default
  os: ubuntu-trusty
  version: latest

### additional features

plans:
- name: deploy-small
  properties:
      persistent_disk: 10xxx
      stemcell: default
      vm_type: small
- name: deploy-large
  properties:
      persistent_disk: 50xxx
      stemcell: default
      vm_type: large
```

Sample bosh commands to deploy feature plans:

```
bosh upload-release foo-bar.tgz
bosh list-plans --release foo-bar

--------------------------------------------------------
Name          Version       Plans
foo-bar       0.0.9+dev.4*  deploy-small, deploy-large
~             0.0.9+dev.3*  deploy-nano
~             0.0.9+dev.1*  deploy--no-ephemeral
--------------------------------------------------------

bosh -d foo-bar-sample-release --release foo-bar --version 0.0.9+dev.4 --plan deploy-small

# it should deploy 
```

# List of elements in default manifest

- cloud-config if needed
- types of plans/vm-types


# Pros:
- Will remove requirement of ODB for services
- Allow easy and flixible intraction with BOSH
- Faster feeback loop for service developers as well as bosh-release developers

# Cons:
- more load on BOSH to maintain plans and deployment types

