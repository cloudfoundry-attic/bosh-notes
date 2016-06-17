# Config Server [PLANNING]

Goals:

- ability to reference config values from a manifest without relying on the client
- ability to generate certain types of properties by default

Currently all solutions involve client side interpolation (eg spiff family, ERB, deployment properties).

Proposal: Introduce optional config API in the Director to fetch property values. Director will evaluate manifests and replace marked values with values fetched via config API. The Director will not store fetched values but rather only keep them in memory. By default BOSH team will include simple config server that will store its values in some database.

## API

The config-server API for create, read and delete is as follows:

- GET /v1/config/&lt;some-key-path>[?version=&lt;version>]
  - returns the configuration value in the specified `version`. If none is specified, the latest version is returned.
  - {"path": "some-key-path", "value": "...", "version": "..."}

- PUT /v1/config/&lt;some-key-path>
  - whenever Director generates a value it will be saved into the config server
  - {"value": "..."}

- DELETE /v1/config/&lt;some-key-path>[?retain-versions=[2,4..6]]
  - if `retain-versions` is specified, all other versions are removed

Values could be any valid JSON object.

### Authentication

Director will use UAA for authentication with the config server. The Director will be configured with a UAA client and secret (similarly to how HM is configured).

## CLI
Go CLI should support the following commands:
- `config login <user> [<password>]` - Get a UAA token for the user. If no &lt;password> is specified it is requested interactively.
- `config set <key> <value>` - Add a new version of &lt;key> with the &lt;value>.
- `config get <key> [<version>]` - Get the value for &lt;key> in &lt;version>. If no version is specified the latest version of &lt;key> is returned.
- `config delete <key> [--retain-versions=<retain-versions>]` - Delete a key. &lt;retain-versions> is a comma separated list of versions and version ranges. It can be used to keep certain versions around, e.g. 2,4..6 to keep versions 2, 4, 5 and 6.
- `config logout` - Drop current UAA token.

## Director integration

### Manifest configuration

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

### Configuration versions

Configuration values can exist in multiple versions. The director always uses the latest version during deployment and stores the relation between deployment/instance_group/property and the configuration/version in the database.

## Stories

- create a release with a simple config server that has a single GET endpoint for fetching a "dummy" (key; /v1/config/dummy) value (2)
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

- director should parse manifest values looking for {{...}} (2)
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

---

- DELETE endpoint should delete a configuration value from the datastore

- DELETE endpoint should allow to specify versions to be retained

- Create simple config-server CLI (e.g. `config`) to hide UAA token handling

```bash
$ config set cf.cc.admin c1oudc0w
Saved value for 'cf.cc.admin'
$ config get cf.cc.admin
c1oudc0w
```

- The config-server CLI should read values from stdin so that secrets don't have to be persisted anywhere

```bash
$ generate_password | config set cf.cc.admin
Saved value for 'cf.cc.admin'
```

- The config-server should keep old versions of my configuration values so that I can access systems that were not re-deployed yet
  - versions are immutable, i.e. you cannot overwrite the value in a particular version
  - if no particular version is requested the latest version is returned

```bash
$ config set cf.cc.admin a
Saved value for 'cf.cc.admin'
$ config set cf.cc.admin b
Saved value for 'cf.cc.admin'

$ config get cf.cc.admin
b
$ config get cf.cc.admin.2
b
$ config get cf.cc.admin.1
a
```

- `bosh deploy` should use the latest version of the configuration so that all my deployments converge on the newest configuration values
   - if I re-deploy everything after a configuration change only the latest versions of configuration values will be used

## TBD

- should links point to specific version of the config value?
- multi value config-server values (eg certificate may contain certificate, private key, and ca certificate)
