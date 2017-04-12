## Tasks config

- Pausing -> rate_limit: 0 workers
- Rate limiting -> X workers at a time
- Priority -> prefer one team over another

```
$ bosh tasks-config
---
tasks:
- options:
    rate_limit: 0
  include:
    deployment:
      - some-name
  exclude:
    deployment:
      - ads

- include: ...
  priority: 1

- include: ...
```
