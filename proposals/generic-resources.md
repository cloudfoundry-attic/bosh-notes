- State: discussing

# Generic resources

```
service_brokers:
 - name: my-kafka-broker
   options:
     url: ...
     client_id:
     client_secret: ...
   provides:
     broker: {as: my-kafka-broker}  # service-broker type

service_instances:
- name: my-kafka-server
  options:
    service_id: kafka-server
    service_plan: ...
  consumes:
    broker: {from: my-kafka-broker} # service-broker type
  provides:
    instance: {as: my-kafka-server} # service-instance type

- name: my-kafka-topic
  options:
    service_id: kafka-topic
    service_plan: ...
  consumes:
    instance: {from: my-kafka-server} # service-instance type
  provides:
    kafka-topic: {as: my-kafka-topic} # service-instance type

manual_providers:
- name: rds
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
     kafka-topic: {from: my-kafka-topic} 
  provides:
     ...

- name: kafka-broker
  provides:
    kafka-broker: {as: my-kafka-broker} 
```

UAA example:

```
jobs:
- name: uaa
  provides:
    admin_creds
- uaa-broker
  consumes:
    admin_creds
  provides:
    uaa_service_broker # type=service-broker

service_instances:
- name: uaa_system_tenant
  options:
    tenant: system
  consumes:
  	uaa_service_broker
  provides:
    uaa_client_creds # type=uaa-client
```

DB example:

```
jobs:
- name: mysql-db
  provides:
    admin_creds
- mysql-db-broker
  consumes:
    admin_creds
  provides:
    db_service_broker # type=service-broker

service_instances:
- name: uaa_db
  options:
    name: uaadb
  consumes:
  	db_service_broker
  provides:
    db_client_creds # type=database
- name: cc_db
  options:
    name: ccdb
  consumes:
  	db_service_broker
  provides:
    db_client_creds # type=database
```
