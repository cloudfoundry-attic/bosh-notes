# [Service] Brokered Links

- https://github.com/openservicebrokerapi/servicebroker

Link consumption definition:

```
consumes:
  db:
    from: db
    [deploment: mysql]
    [network: external]
    service_broker:
      url: ...
      username: ...
      password: ...
      certificate:
        ca: ..
        certificate: ...
        private_key: ...
    service_instance:
      service:
      plan:
      name: /lol
      parameters:
        ...
    service_binding:
      parameters:
        max_connections: 100
```

- service_broker section is optional if link is being provided by a type=service_broker?
- variables could be used anywhere in the definition

Response from the service binding would be:

- bosh compatible: inside `credentials` (https://github.com/openservicebrokerapi/servicebroker/blob/master/spec.md#body-6) object one can find instances and properties?

```
{
  "instances": [{"address": ...}],
  "properties": {...}
}
```

- traditional:

```
{
  "uri": "mysql://mysqluser:pass@mysqlhost:3306/dbname",
  "username": "mysqluser",
  "password": "pass",
  "host": "mysqlhost",
  "port": 3306,
  "database": "dbname".
  "instances": [{"address": ...}],
}

-->

{
  "instances": [{"address": ...}],
  "properties": {...}
}
```

- standard for db connections? etc?
- how about link.address(...)?
- see "Link casting" section below

## Examples

```
name: dep1

instance_groups:
- name: app
  jobs:
  - name: app
    consumes:
      # consuming regular link
      primary_db:
        from: db
        deployment: mysql

      # impliclty consuming brokered link
      primary_db:
        from: db
        deployment: mysql

      # consuming brokered link with custom options
      primary_db:
        from: db
        deployment: mysql
        options:
        	asdf

      # potential spec for consuming brokered link from a remote service broker
      primary_db:
        service_broker:
          url: ...
          ca: ...
          creds:
        service_instance:
          name: ...
        service_binding:
          database: foo

      # current spec for manual linking
      primary_db:
        instances:
        - address: ...
          az: ...
          index: ...
        properties:
          ...
```

And potentially a different deployment providing a link:

```
name: dep2

instance_groups:
- name: mysql
  jobs:
  - name: mysql-server
    provides:
  - name: mysql-broker
    provides:
      db:
        shared: true
        brokered: true
        service_instance:
          name:
      xxx: # any name with type=service-broker
```

Example of an ops file that opts into a DB link:

$ bosh deploy wordpress.yml -o custom-elephant-db.yml

```
- type: replace
  path: /instnace_gorups/name=app/jobs/name=app/consumes/primary_db
  value:
	  service_broker:
      api:
  	    url: ...
  	    ca: ...
  	    creds:
	  service_instance:
      service:
      plan:
      name: /lol
	    parameters:
        ...
  	service_binding:
      parameters:
  	    max_connections: 100

- type: replace
  path: /instnace_gorups/name=app/jobs/name=app/consumes/primary_db
  value:
    service_broker:
	    from: db
	    deployment: mysql
  	  instance:
  	    name: foo
```

## Generic broker

```
name: generic-broker

provides:
- name: generic
  type: service-broker
  properties:
  - url
  - username
  - password
  - certificate.ca

properties: {...}
```

Generic broker can call to following scripts on colocated VM:

```
/var/vcap/jobs/whatever/bin/create-binding
/var/vcap/jobs/whatever/bin/delete-binding
```

## Link casting

```
name: db-mapper

consumes:
- name: db
  type: database

provides:
- name: db
  type: database
  properties_template: config/db.erb # possible custom mapping?
  properties:
  - name: username
    template: config/username.erb
```

config/db.erb

```
JSON.dump(
  "username" => link("db").p("other-broker.username"),
  "password" => link("db").p("other-broker.password"),
)
```

config/username.erb

```
<%= link("db").p("other-broker.username") %>
```

## TBD

- namespacing service instances
  - can we use / in names?
- implicit linking
  - new service instance?
- service instance lifecycle
  - orphaned service instance just like persistent disks
  - `delete_on_termination: true` ?
