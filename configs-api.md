# Common configs API

Director now (or in upcoming releases) manages multiple types of configs:

```
cloud (implemented)
- azs (array)
- networks (array)
- vm_types (array)
- vm_extensions (array)
- disk_types (array)
- compilation (hash)

cpi (implemented)
- cpis (array)

runtime (implemented)
- tags (hash)
- update (hash)
- addons? (array)

tasks (upcoming)
- rules (array)

resurrection (upcoming)
- rules (array)

config-server (possible)
- rules (array)
```

Commonalities:

- common set of CLI commands
  - bosh update-X-config
  - bosh X-config
  - bosh X-configs?
- common set of API endpoints
- diffing functionality
- version tracking
  - some configs are referenced by their version from other objects (like deployments)
- multiple named "branches"
- record of events

There is also desire to have multiple "branches" of configs (named) so that not all functionality have to be kept within a single file. For example operator may want to split runtime config into particular configurations managed by different teams or other operators. Another use case is for configuring DNS release globally in a runtime config without requiring users to merge their own addons configuration.

## Proposed

Following API endpoints would replace current ones (in a backwards compatible):

```
GET  /configs/:type
	[{ id: "138748", name: asdf, config: "asdf\nasdf" }]

GET  /configs/:type?name=...&id=x
  { id: "138748", name: asdf, config: "asdf\nasdf" }

POST /configs/:type?...&name=...
  - no name -> name="" (default)
  { id: "138748", name: asdf, config: "asdf\nasdf" }

POST /configs/:type/diff[?id=x[&id2=x]]
  { diff: [...], error: "" }

POST /configs/:type/authorization
  ?
```

Note: IDs are unique within a "type".

We'll still provide common commands for cloud-config, cpi-config, etc but we will also provide generic commands:

```
$ bosh update-config type file.yml --name ...
$ bosh configs       type [--name ... --version ...]
```

## TBD

- bosh cloud-config shows collapsed view?
