- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

CLI should provide a way to find different versions of configs stored in the Director.

# Motivation

Use cases:

- see previous versions of configs
- ability to diff older configs
- ability to diff against an older config

# Details

Proposed API additions:

```
POST /config_diffs
  req: { from: { ... }, to: { type: asdf, name: asdf, content: "asdf\nasdf" } }
  req: { from: { id: "1" }, to: { id: "2" } }
  resp: { diff: [...], error: "" }
  - if from is not specified pick last based on type/name specified in to
  - to is required
```

Proposed CLI changes:

...

# Drawbacks

...

# Unresolved questions

...
