- State: discussing

# Property Validation

Goals:

- improve validation semantics of certain job property types
- ability to generate certain types of properties by default

Proposal: Add property types to jobs, and validate them in the beginning of the deploy.

## Types

Types will be validated in the Director when evaluating the manifest.

### Basic types

- int (any number)
- float
- string
- bool
- array
- hash

It's out of scope to define nested types (eg array of hashes with specific keys and strings?) for now; however, they could be later defined as something like this:

- [{"user": "int", "stuff": "bool"}]

It's out of scope to define custom type or validators aside from provided by the Director.

### Specific types

- port (1 through 65535)
  - ports will eventually be used to automatically select non-conflicting ports for jobs in an instance group
- secret
- certificate

### Validations

Basic validations will be provided by the Director and configured in the release metadata. The Director will provide validations:

```
properties:
  collector.logging_level:
    description: "the logging level for the collector"
    default: info
    type: string
    validate:
      values: [info, debug, debug2]
```

It's out of scope to provide more complex cascading validations via metadata. Given that ERB templates allow flexible configuration checking any kind of more complex validations should be done there. For example, if one property is provided then another property is required.

List of basic validations:

- regex
  - applies to string, int, port
- values
  - applies to string, int, bool, port

### Release property configuration

Types could be specified in the job spec for each property. Director will validate validity of types and validations when release is uploaded to the Director. Example:

```yaml
name: collector

templates: {...}

packages: [...]

properties:
  aws.access_key_id:
    description: "AWS access key for CloudWatch access"
    type: string
    validate:
      regex: /\AAKI.+\z/

  log_level:
    description: "the logging level for the collector"
    default: info
    type: string
    validate:
      values: [info, debug, something]

  intervals.discover:
    description: "the interval in seconds that the collector attempts to discover components"
    default: 60
    type: int
    validate:
      positive: true

  use_graphite:
    description: "enable Graphite plugin"
    default: false
    type: bool

  graphite.port:
    description: "TCP port of Graphite"
    default: 4001
    type: port
```

## Stories

- upload release command should types specified by the release
- upload release command should validate default values against the type

## TBD

- nil values
  - do we validate values if they are non-nil?
- validating values provided by the config server
