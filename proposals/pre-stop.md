- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

As a release author, I expect that I can stop my jobs running via more standard script interface which relies on exit code to determine success (instead of drain which relies of stdout).

# Motivation

It's been reported that drain hook semantics are not consistent with all other hooks, hence, its hard to get right.

# Details

For backwards compat we will continue to support drain hook. New Directors will call pre-stop hook in after drain. 

- unmonitoring services
- passing environment variables

# Drawbacks

...

# Unresolved questions

...
