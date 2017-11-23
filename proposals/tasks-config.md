- State: in-progress

# Summary

There needs to be a way to configure Director to rate limit, prioritize etc task executions so that tasks could be executed in a manner acceptance to the operators.

# Details

We could group task limiting like so:

- Rate limit
  - Limit certain group of tasks so that only X of them can run
  - Limit certain group of tasks so that none of them can run (X=0)
- Priority
  - Prefer one team's tasks over another
  - Prefer one deployment's tasks over another
  - Prefer particular task types (vms, ssh, logs) over another

Given that Director now supports consolidated configs API, we can define a new config type: `tasks` with the following format:

```yaml
tasks:
- options:
    rate_limit: 0
  include:
    deployments:
    - include-dep1
    - include-dep2
    teams:
    - team-1
  exclude:
    deployments:
    - exclude-dep10

- options:
    priority: 100
  include:
    task_types: [vms, ssh, logs]
```

(set via `bosh update-config tasks tasks.yml`)

`options` key can include 2 configurations:

- `rate_limit` [Integer] which represents maximum number of tasks running at a time
- `priority` [Integer] which represents relative priority between tasks

`include`/`exclude` declrations follow same rules as addons' include/exclude rules. Only `deployments`, `tasks` and `task_types` keys are allowed.

# TBD

- Director API rate limiting outside of tasks
- Should multiple resurrection configs be allowed?
- Should there be a way to define X number of tasks that can run in parallel?
