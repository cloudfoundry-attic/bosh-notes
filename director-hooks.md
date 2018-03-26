- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related issues: [#261](https://github.com/cloudfoundry/bosh-cli/issues/261)

# Summary

As a Director user I expect to be able to configure hooks to agument Director functionality with more advanced integrations such as stemcell downloading, compiled release downloading, deployment manifest validation, etc.

# Motivation

Use cases:

- stemcell downloading
- release downloading
- config validation
  - make sure that stemcell version less than X is not used

# Details

...

# Drawbacks

...

# Unresolved questions

- long running hooks - how to indicate progress?
- hook installation locations (https vs colocate)
- hooks that are team specific?
- resolution of stemcell and release versions
  - do not want to duplicate logic in director and hook
