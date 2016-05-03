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

```
properties:
  web_ui.port:
    description: Port that web_ui app listens on
    default: 80
    type: port     # validator checks if the value is int,
                   # belongs to 1..65535 range and
                   # other jobs on this instance_group don't have such value
```

Other validations:

```
properties:
  web_ui.support.email:
    description: "Support email address."
    regexp: /\A(.*)@(.*)\.(.*)\z/
    type: string
```


## Possible implimentation (step by step)

Here is a scope of work devided by steps:

1. _Job spec should be saved to bosh director database_, when BOSH release is uploaded. At this moment
spec is already present in bosh release in job artifact (in `job.MF` file) without changes, this means
we can pass meta data together with bosh release archive to bosh director. On `bosh-director` side
we need to create model for release properties and store them during `POST / `. This is processed by
`ReleasesController`.
1. Add possibility to `bosh-director` to get BOSH release specs via BOSH director API. Changes to ReleasesController controller to return meta data on `GET /releases/:name/spec` request.
1. Add possibility to `bosh_cli` to run built-in and custom validators.
