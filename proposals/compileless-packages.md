- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related: [https://github.com/cloudfoundry/bosh/issues/1946](https://github.com/cloudfoundry/bosh/issues/1946)

# Summary

As a release user, I want to be able to mark certain packages as "compileless" so that Director can just use source bits as its "compiled" bits.

# Motivation

Example usages:

- CF buildpacks
- CF rootfses
- Docker images
- precompiled golang binaries (or static binaries in general)

# Details

As a proposed solution, let's add a flag to regular package spec to indicate that package shouldnt be compiled.

```
name: pkg1
compile: false
dependencies:
- pkg2
```

# Drawbacks

...

# Unresolved questions

- TBD: better name
