# Manifest Features

Sometimes it's necessary to feature flag certain features in a very explicit manner. Examples:

- BOSH native DNS opt-in
- Cloud config [old]
- Manifest strictness checking

Proposed manifest format:

```yaml
name: ...

features:
  use_dns_addresses: bool
  strict: bool

instance_groups:
- name: zookeeper
  ...
```
