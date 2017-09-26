# Generic resources

```
resources:
- name: foo
  type: service-broker
  ...

- name: foo
  type: director
  ...

- name: foo
  type: service-instance
  options:
    service_id: elb
  provide:
    lbs: {as: my-lb}

# - name: my-kafka-broker
#   type: service-broker
#   options:
#     url: ...
#     client_id:
#     client_secret: ...
#   provides:
#     broker: {as: my-kafka-broker}  # service-broker type

- name: my-kafka-server
  type: service-instance
  options:
    service_id: kafka-server
    service_plan: ...
  consumes:
    broker: {from: my-kafka-broker} # service-broker type
  provides:
    instance: {as: my-kafka-server} # service-instance type

- name: my-kafka-topic
  type: service-instance
  options:
    service_id: kafka-topic
    service_plan: ...
  consumes:
    instance: {from: my-kafka-server} # service-instance type
  provides:
    kafka-topic: {as: my-kafka-topic} # service-instance type

- name: my-kafka-creds
  type: service-binding
  options:
    readonly: true
  consumes:
    binding: {from: my-kafka-instance} # kafka type?

- name: rds
  type: manual
  provides:
    database:
      type: database
      address: ...
      instances: [...]
      properties:
    database-creds:
      type: database-creds
      properties:

jobs:
- name: foo
  consumes:
     kafka-instance: {from: my-kafka-instance} 
  provides:
     ...

- name: kafka-broker
  provides:
    kafka-broker: {as: my-kafka-broker} 
```
