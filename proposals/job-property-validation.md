- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

As a release author, I would like to specify simple validation rules for property values.

# Motivation

When looking at current BOSH releases, you often see logic that validates the input for being the correct type. While this works, it makes the ERB templates more complex and more of a checklist, than really filling out just a template. Some releases also opt to fly blind, which leads to non-starting VMs. If a autor could set simple validation rules in the spec file, a lot of this validation logic could be removed from code. For a first draft I would suggest something like this:
```yaml
  garden.network_mtu:
    description: "Maximum network transmission unit length in bytes. Defaults to the mtu of the interface that the host uses for outbound connections. Max allowed value is 1500. Changed value applies only to newly created containers."
    default: 0
    type: Integer
```
alternatively, Regex matching could be used. Additionally, default values should always be returned if a value is not set (this would reduce amount of if_p where the default value is hardcoded.

# Details

...

# Drawbacks

...

# Unresolved questions

...
