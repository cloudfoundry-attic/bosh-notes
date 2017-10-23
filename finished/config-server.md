# Config Server [FINISHED]

Goals:

- ability to reference config values from a manifest without relying on the client
- ability to generate certain types of properties by default

Currently all solutions involve client side interpolation (eg spiff family, ERB, deployment properties).

Proposal: Introduce optional config API in the Director to fetch property values. Director will evaluate manifests and replace marked values with values fetched via config API. The Director will not store fetched values but rather only keep them in memory. By default BOSH team will include simple config server that will store its values in some database.

## API

Following public API will be used by the Director to contact config server:

- GET /v1/data/\<some-id>
  - whenever Director needs to retrieve a value it will use GET action
  - Request: \<nothing>
  - Response: 200 OK { "name": "\<some-key-name>", "type": "value", "value": \<any json value> }

- DELETE /v1/data/?name=\<some-key-name>
  - user can delete config values
  - Request: \<nothing>
  - Response: 200 OK

- PUT /v1/data/\<some-id>
  - manual config value update
  - Request: { "type": "certificate", "value": \<any json value> }
  - Response: 200 OK

- POST /v1/data
  - whenever Director generates a value it will be saved into the config server
  - Request: {
      "name": "<some-key-name>",
      "type": "value",
      "parameters": { \<opaque> }
    }
  - Response: 200 OK

### Generic value generation parameters

The Director will not include any params when generating generic value.

### Certificate generation parameters

The Director will include following params when generating certificates.

```
{
  "type": "certificate",
  "parameters": {
    "common_name": "bosh.io",
    "alternative_name": ["blah.bosh.io", "10.10.10.1"],
  }
}
```

Values could be any valid JSON object.

### Authentication

Director will use UAA for authentication with the config server. The Director will be configured with a UAA client and secret (similarly to how HM is configured).

## Manifest configuration

When manifest includes "((key-name))" directive it will be parsed out by the Director and value associated with "key-name" will be retrieved from the config server. This should happen before manifest is used for determining if instances need an update.

Example how manifest may reference values:

```
instance_groups:
- name: nats
  jobs:
  - name: nats
    release: nats
    properties:
    	password: ((nats.password))
```

Note that the Director should first parse YAML manifest and only then replace leaf values using curly braces. This does not allow to do something like this: "https://api.{{domain}}".

Client side replacement of "((...))" will not be affected.

## Director ID management

It's useful for some Director clients to know which config server IDs are still in use anywhere within a Director and/or a deployment. These clients may use that information to determine when it's ok to delete a config server entry, or to update it for rotation.

Following is a proposed endpoint for Director wide check:

GET /vars/var1-id?include-value=false

- 404 Not Found if ID is not used by the Director in any of the deployments.
- 200 OK if it's used
- supports only `include-value=false`

```json
{
  "id": "var1-id",
  "name": "/director/dep1/var1"
}
```

GET /deployments/dep1/vars?include-value=true

- Returns all config server values used by that deployment

```json
[
  {
    "id": "var1-id",
    "name": "/director/dep1/var1",
    "value": \<any json value>
  },
  {
    "id": "var2-id",
    "name": "/director/dep1/var2",
    "value": \<any json value>
  }
]
```

TBD:
- how to deal with multiple versions
- how to deal with namespacing? (keep it or not?)

## Stories

- create a release with a simple config server that has a single GET endpoint for fetching a "dummy" (key; /v1/data/dummy) value (2)
  - return dummy value right now
  - write config server in go
  - return 404 if value doesnt exist (non-dummy path)
- add PUT endpoint that saves value such that GET endpoint returns it (2)
  - in memory configuration
- allow config server to *fetch* value from a database table (4)
  - add necessary database configuration to the release job (connection url or 2-3 props split out)
  - keep in-memory configuration as a possibility (backend config)
  - assume that a table in the database exists
  - GET endpoint should return a value written to a DB
  - see what concourse does for its db
- allow config server to write value to a database table (1)
  - implement PUT to save into db
  - hopefully we have a little go interface for storing/getting things
- automatically create DB table on config server start (2)
  - value should be text
  - dont create table if already exists
  - see what concourse does

---

- director should parse manifest values looking for ((...)) (2)
  - feature flag it as director.parse_config_values
  - only evaluate properties and env sections
  - return one error per key in the manifest
- director should return errors when config server doesnt have keys (2)
  - hook it up to the config server (https url, ca_cert field, always validate https)
  - return error in the Director task since config server returns 404
- director should replace keys in the manifest with found values from the config server (2)
  - ensure that ERB templates could access replaced info via p and its friends
- dont show config values when diffing manifest (4)
  - even when it's --no-redact
  - show curlies in non redacted case
  - still show lines for changed values
- ensure that director doesnt print interpolated manifest to the debug log (4)
  - download manifest should have curlies as input
  - audit where passwords might be saved into the db
- director should evaluate link information (4)
  - do same as parsing manifest
- director should evaluate runtime config for referenced props during bosh deploy (2)

---

- validate UAA token in the config server
  - only allow "config-server.admin" scope?
- director should include UAA token when making a request to the config server
  - show error from the config server when token is not valid

## TBD

- should links point to specific version of the config value?
- multi value config-server values (eg certificate may contain certificate, private key, and ca certificate)
