- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Operator should select zero or more instances for particular activity such as deploy, run-errand, delete, etc.

# Motivation

...

# Details

```
bosh deploy --instance group
bosh deploy --instance az=z1,az=z2
bosh deploy --instance responsive
bosh deploy --stages recreate --instance unresponsive
```

```
bosh run-errand status --instance responsive
bosh run-errand status --instance az=z1
bosh run-errand status --instance label=master
```

# Drawbacks

...

# Unresolved questions

...
