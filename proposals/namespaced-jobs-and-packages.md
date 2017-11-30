- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

BOSH should allow jobs and packages with the same name coexist on the same VM.

# Motivation

Use cases:

- support multiple copies of the same job
- support multiple packages from different releases that depend on a package with the same name (but not the same fingerprint)

# Details

...

# Drawbacks

...

# Unresolved questions

- compilation dependency (non-relocatable packages)
