# Release properties validations in manifest [PLANNING]

[Initial discussion](https://github.com/cloudfoundry/bosh-notes/issues/11).

## Description

A lot of errors during deployment occur because of a "human factor". Errors in BOSH 
manifests can be caused by misspelling or misunderstanding of BOSH release properties. 
Even if BOSH can check some type of errors in manifest properties, often it is not enough.

The validation should be built meta information provided by BOSH release developers, 
because only them know better the context. Such validations should be performed by `bosh_cli` 
before triggering deployment process. This means `bosh_cli` should get this meta information
from bosh-director.

BOSH release contains description of its properties in `jobs/*/spec` files. Currently properties in
spec gives you only two possible fields: `description` and `default`. Extending this list will 
allow to provide better user experience for BOSH users. Such fields like `type` and `regexp` will
allow to prevent a lot of human made errors in manifests.

At the same time `bosh_cli` can provide more complex validations based on deployment manifest. 
With small efforts it is also possible to add possibility to create custom validators for `bosh_cli`.
This shouldn't affect load time of `bosh_cli`.

## Examples

Ports:

```yaml
properties:
  web_ui.port:
    description: Port that web_ui app listens on
    default: 80
    type: port     # validator checks if the value is int,
                   # belongs to 1..65535 range and
                   # other jobs on this instance_group don't have such value
```

Other validations:

```yaml
properties:
  web_ui.support.enabled:
    description: "Support service is enabled."
    type: bool
  web_ui.support.email:
    description: "Support email address."
    regexp: "/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i"
    type: string
    when: web_ui.support.enabled      # run validations only if
                                      # web_ui.support.enabled is set to true
```

## Possible implimentation (step by step)

Here is a scope of work devided by steps:

1. Job spec should be saved to bosh director database, when BOSH release is
uploaded. At this moment custom properties are already present in bosh release
as job artifact (in `job.MF` file) without changes, this means we can pass
meta data together with bosh release archive to bosh director. Still it would
be nice to add an integration test for this case.
1. On `bosh-director` side we need to create model for release properties and
store them while creating release. Release properties model can contain
properties as yaml string (like it is done for cloud config model). Release properties model should have many-to-one relation with release and many-to-many with release versions.
1. Add endpoint to `bosh-director` to get BOSH release spec properties via
BOSH director API. For instance on `GET /releases/:name/spec` request.
1. Add possibility to `bosh_cli` to run built-in and custom validators.
