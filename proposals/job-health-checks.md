- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Release authors should be able to specify structured health checks to indicate whether job is healthy or unhealthy.

# Motivation

...

# Details

bosh events --instance first/aad724d2-c093-4114-a433-0feccfb5ed6c

- healthcheck event includes health checks (code, message)

Example health checks:

- is my cluster size=3? (from cf-mysql-release)

# Drawbacks

...

# Unresolved questions

- timeouts?
- common checks?
