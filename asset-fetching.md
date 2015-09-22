# Asset Fetching

It's inconvenient to have to manually issue commands to the Director to download releases and stemcells before doing a deploy. Similarly to how bosh-init automatically fetches necessary assets, the CLI/Director should be able to perform the same thing.

## URLs

Following schemes are supported (see examples below):

- `http` and `https`
  - `sha1` is required
- `file`
  - path is relative to the manifest's directory
  - `~` is expanded
  - `sha1` is not required

## Releases

```yaml
releases:
- name: bosh
  version: 207
  url: https://bosh.io/d/github.com/cloudfoundry/bosh?v=207
  sha1: 5f835bad5fc46230cd2fa823c0a52a94829ee044
- name: diego
  version: 0.1431.0
  url: https://bosh.io/d/github.com/cloudfoundry-incubator/diego-release?v=0.1431.0
  sha1: 431007e2756926d60a988d12682bb0a44e7afe3d
```

## Stemcells

```yaml
resource_pools:
- name: default
  network: default
  stemcell:
    name: bosh-aws-xen-hvm-ubuntu-trusty-go_agent
    version: 3074
    url: https://bosh.io/d/stemcells/bosh-aws-xen-hvm-ubuntu-trusty-go_agent?v=3074
    sha1: 5f835bad5fc46230cd2fa823c0a52a94829ee044
  cloud_properties:
    instance_type: m3.medium
```

And in future:

```yaml
stemcells:
- alias: default
  os: ubuntu-trusty
  version: 3074
  urls:
    aws:
      url: https://bosh.io/d/stemcells/bosh-aws-xen-hvm-ubuntu-trusty-go_agent?v=3074
      sha1: 5f835bad5fc46230cd2fa823c0a52a94829ee044
    openstack:
      url: https://bosh.io/d/stemcells/bosh-openstack-kvm-ubuntu-trusty-go_agent?v=3074
      sha1: 431007e2756926d60a988d12682bb0a44e7afe3d
    ...
```

Unlike releases, since currently stemcells are IaaS specific, we would have to

## Stories

- [PR 954](https://github.com/cloudfoundry/bosh/pull/954)

## TBD

- automatically create and upload a release if file path point to a release directory
