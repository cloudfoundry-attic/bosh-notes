- State: in-progress

# Summary

HM should allow much more granular configuration for which deployments/jobs/instance groups should be resurrected.

# Details

Given that Director now supports consolidated configs API, we can define a new config type: `resurrection` with the following format:

```yaml
rules:
- options:
    enabled: false
  include:
    deployments:
    - dep1

- options:
    enabled: true
  include:
    deployments:
    - dep1
    instance_groups:
    - api
```

(set via `bosh update-config resurrection resurrection.yml`)

By default HM will continue to resurrect by default unless it finds resurrection configuration that disables it for a particular set of deployment or instance groups.

`options` key can include 1 configuration:

- `enabled` [Boolean] which represents whether resurrection should occur or not.

`include`/`exclude` declrations follow same rules as addons' include/exclude rules. Only `deployments` and `instance_groups` keys are allowed.

# TBD

- Should multiple resurrection configs be allowed?
