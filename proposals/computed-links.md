- State: discussing
- Start date: ?
- End date: ?

# Summary

It should be possible for a job to control contents of a provided link via an ERB template.

# Motivation

Use cases:

- rename properties exposed in a link from job properties
- expose only certain portions of properties or pieces of data

Above use cases could be typically found as release authors migrate their releases to use links.

Future possible use cases:

- allow link type coersion to aid release compatibility

# Details

Currently release authors have to specify following metadata in a job spec when providing a link:

```yaml
provides:
- name: primary-db
  type: database

- name: backup-db
  type: database
  properties:
  - username
  - password

properties:
  username:
    description: ...
  password:
    description: ...
```

Above declaration is very constrained as it does not provide any flexbility with defining different property structure.

Proposed configuration allows release authors to define custom ERB template to define link contents:

```yaml
templates:
  backup-db.json: config/backup-db.json

provides:
- name: backup-db
  type: database
  template: backup-db.json

properties:
  username:
    description: ...
  password:
    description: ...
```

Contents of backup-db.json will be:

```ruby
<%=

JSON.dump(
  "properties" => {
    "custom_username" => p("username"),
    "custom_password" => p("password"),
  },
)

%>
```

Notes:

- `templates` section must include link template or otherwise it will not be picked up by the CLI (need to be verified); as a side note, it does mean that rendered link template will be visible on the job's filesystem.

- in a first iteration of this feature we should not allow computed links to reference other links within its template to avoid determining link dependency tree. if `link(...)` accessor is used, behavour will be undefined.

- to achieve backwards compatiblity Director will ignore `properties` key defined on the provides directive if `templates` key is specified.

# TBD

- should we allow address or instances keys in the link contents?
- how do you reference root section of properties?
