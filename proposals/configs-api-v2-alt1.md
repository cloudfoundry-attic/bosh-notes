- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related proposals: [proposals/configs-api-v2.md](proposals/configs-api-v2.md)

# Summary

CLI should provide a way to find different versions of configs stored in the Director.

# Motivation

Use cases:

- see previous versions of configs
- ability to diff older configs
- ability to diff against an older config

# Details

## Proposed CLI changes

```
$ bosh update-config `path` --type xxx --name xxx [--expected-latest-id=xxx]
<shows diff>
<confirmation>
ID         ...
Type       ...
Name       ...
Created at ...
```

- positional `path` is required
- `--type` and `--name` are required (diff from previous optional --name)

```
$ bosh delete-config [id] [--type xxx] [--name xxx]
<succeeded>
```

- in future delete by id as well?

```
$ bosh configs [--type xxx] [--name xxx] [--recent=1000]
ID  Type   Name     Created At
13  cloud  default  ...
12  cloud  default  ...
```

- alayws shows id, type, name, created-at
- `--recent=` (default to 30) (consistent with bosh tasks --recent)

```
$ bosh diff-config [--from-id X] [--from-content X] [--to-id X] [--to-content X]
From ID ...
To ID   ...
Content ...
```

- example: `bosh diff-config --from-id X --to-content new-cfg.yml`
- no positional args
- requires one of id|content for from/to

```
$ bosh config [id] [--type xxx] [--name xxx]
ID         ...
Type       ...
Name       ...
Created at ...
Content    ...
```

- transposed table similar to `bosh event` cmd (planning to change bosh task as well)
- show latest copy
- id is optional (similar to bosh ssh IG)
- content could be printed to stdout by using `... --column content > ...`
- should allow deleted config for debugging deployments that still reference it

```
$ bosh merged-config [--type xxx]
<content>
```

- possible future addition

```
$ bosh deployments
name  releases  stemcells  configs
                           123 cloud/default latest
                           124 runtime/default
                           125 runtime/ipsec
```

- possible future addition

## Proposed API additions

```
POST /configs/diff
  req: { from: { ... }, to: { type: asdf, name: asdf, content: "asdf\nasdf" } }
  req: { from: { id: "1" }, to: { id: "2" } }
  resp: { diff: [...], error: "" }
  - if from is not specified pick last based on type/name specified in to
  - to is required
```

# Drawbacks

- above changes do break compat hence we would version this as v3.0.0

# Unresolved questions

...
