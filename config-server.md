# Config Server [PLANNING]

Goals:

- ability to reference config values from a manifest without relying on the client
- ability to generate certain types of properties by default

Currently all solutions involve client side interpolation (eg spiff family, ERB, deployment properties).

Proposal: Introduce optional config API in the Director to fetch property values. Director will evaluate manifests and replace marked values with values fetched via config API. The Director will not store fetched values but rather only keep them in memory. By default BOSH team will include simple config server that will store its values in some database.

## API

Following public API will be used by the Director to contact config server:

- GET /v1/config/&lt;some-key-path>
  - whenever Director needs to retrieve a value it will use GET action
  - {"path": "some-key-path", "value": "..."}

- PUT /v1/config/&lt;some-key-path>
  - whenever Director generates a value it will be saved into the config server
  - {"value": "..."}

Values could be any valid JSON object.

### Authentication

Director will use UAA for authentication with the config server. The Director will be configured with a UAA client and secret (similarly to how HM is configured).

## Manifest configuration

When manifest includes "{{key-name}}" directive it will be parsed out by the Director and value associated with "key-name" will be retrieved from the config server. This should happen before manifest is used for determining if instances need an update.

Example how manifest may reference values:

```
instance_groups:
- name: nats
  jobs:
  - name: nats
    release: nats
    properties:
    	password: {{nats.password}}
```

Note that the Director should first parse YAML manifest and only then replace leaf values using curly braces. This does not allow to do something like this: "https://api.{{domain}}".

Client side replacement of "{{...}}" will not be affected.

## Stories

- create a release with a simple config server that has a single GET endpoint for fetching value a dummy value
  - return dummy value right now
  - write config server in go
  - return 404 if value doesnt exist
- add PUT endpoint that saves value such that GET endpoint returns it
  - in memory configuration
- allow config server to fetch value from a database table
  - add necessary database configuration to the release job
  - keep in-memory configuration as a possibility
  - assume that a table in the database exists
  - GET endpoint should return a value written to a DB
- allow config server to write value to a database table
- automatically create DB table on config server start
  - value should be text

---

- director should parse manifest values looking for {{...}}
  - feature flag it as director.parse_config_values
  - only evaluate properties and env sections
- director should return errors for each key in the manifest
  - at this point director is not configured with any config server
  - return one error per key in the manifest
- director should return errors when config server doesnt have keys
  - return error since config server returns 404
- director should replace keys in the manifest with found values from the config server
  - ensure that ERB templates could access replaced info via p and its friends
- dont show config values when diffing manifest
- ensure that director doesnt print interpolated manifest to the log
- director should evaluate link information

---

- validate UAA token in the config server
  - only allow "config-server.admin" scope?
- director should include UAA token when making a request to the config server
  - show error from the config server when token is not valid

## TBD

- should links point to specific version of the config value?
- multi value config-server values (eg certificate may contain certificate, private key, and ca certificate)
