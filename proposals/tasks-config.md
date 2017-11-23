- State: in-progress

## Tasks config

- Pausing -> rate_limit: 0 workers
- Rate limiting -> X workers at a time
- Priority -> prefer one team over another
- Time sharing between teams (or X)
- Prioritize based on type of task (vms, ssh, etc.)

```
$ bosh tasks-config
---
tasks:
- options:
    rate_limit: 0
  include:
    deployment:
      - some-name
    jobs: [...]
    teams: [...]
  exclude:
    deployment:
      - ads

- include: ...
  priority: 1

- include: ...
```

## TBD

- Director API rate limiting outside of tasks
