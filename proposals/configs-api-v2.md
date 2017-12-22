- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related proposals: [proposals/configs-api-v2-alt.md](proposals/configs-api-v2-alt.md)

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
POST /configs/diff
  req: { from: { ... }, to: { type: asdf, name: asdf, content: "asdf\nasdf" } }
  req: { from: { id: "1" }, to: { id: "2" } }
  resp: { diff: [...], error: "" }
  - if from is not specified pick last based on type/name specified in to
  - to is required
```

Proposed CLI changes:

New flag `--include-outdated` to display also outdated versions of a config. The column `ID` is shown to reference an outdated version for follow-up commands. All other filtering for `name` and `type` applies as usual.

```
$ bosh configs --include-outdated
Using environment '192.168.50.6' as client 'admin'

ID  Type            Name
7   cloud           default
3   ~               ~
1   ~               ~
6   ~               service-fabrik
2   kartoffelsalat  default
4   runtime         default
5   ~               ipsec

7 configs
```

New command `bosh diff-configs` to show a diff between two versions of a config.
```
$ bosh diff-configs 7 3
Using environment '192.168.50.6' as client 'admin'

  azs:
- - cloud_properties:
-     availability_zone: nova
-   name: z3

  disk_types:
- - disk_size: 50000
-   name: large
```

New parameter `--version=` to be added to `bosh config` to receive an outdated version of a single config

```
$ bosh config --version=3
Using environment '192.168.50.6' as client 'admin'

azs:
- cloud_properties:
    availability_zone: nova
  name: z1
- cloud_properties:
    availability_zone: nova
  name: z2
- cloud_properties:
    availability_zone: nova
  name: z3
(...)

Succeeded
```

...

# Drawbacks

...

# Unresolved questions
* should we offer convenience to refer to versions, e.g. string `latest` and git-like syntax like `latest~1`?
...
