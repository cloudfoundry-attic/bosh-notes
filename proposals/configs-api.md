- State: finished

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
GET /configs?[name=asdf][&type=asdf][&latest=true]
  resp: [{ id: "138748", type: asdf, name: asdf, content: "asdf\nasdf" }]
  - any combination of name, type, latest is allowed

GET /configs/:id
  resp: { id: "138748", type: asdf, name: asdf, content: "asdf\nasdf" }

POST /configs
  req: { type: asdf, name: asdf, content: "asdf\nasdf" }
  resp: { id: "138748", type: asdf, name: asdf, content: "asdf\nasdf" }
  - name and type are always required

DELETE /configs?[name=asdf][&type=asdf]
  resp: 200 OK

POST /config_diffs
  req: { from: { ... }, to: { type: asdf, name: asdf, content: "asdf\nasdf" } }
  req: { from: { id: "1" }, to: { id: "2" } }
  resp: { diff: [...], error: "" }
  - if from is not specified pick last based on type/name specified in to
  - to is required
```

Note: IDs are unique across everything.

We'll still provide common commands for cloud-config, cpi-config, etc but we will also provide generic commands:

```
$ bosh update-config type file.yml --name ...
$ bosh configs       type [--name ... --version ...]
```

## TBD

- bosh cloud-config shows collapsed view?
