# Links [IN PROGRESS]

To configure non-simplistic deployment where at least one deployment job knows about another, operators have to either assign static IPs or DNS names to one job and pass it via properties to the other. This configuration is error-prone and unnecessary. It is also hard to automate for the case of service brokers creating deployments on demand.

Currently the Director favors deployments/environments with manual networking (the Director assigns IPs to the deployment jobs) because it does not come with a HA DNS service. (See separate proposal regarding HA DNS.) In addition to that limitation even if HA DNS was provided operators would still have to configure certain deployment jobs to have static IPs.

Links provide a solution to the above problem and abstract away manual vs dynamic (DNS based networking) from the deployment jobs. In addition to that links can also be used to share other non-networking configuration (job properties) between deployment jobs.

From the operator perspective introduction of links removes tedious cross-referencing of IPs and in future other properties.

---
### Release schema for job specs

```yaml
name: proxy 					# String, non-empty

consumes: 						# Array or nil/not-specified
- name: data-node 		# String, non-empty, unique within requires
  type: data-node 		# String, non-empty, non-unique

provides: 						# Array or nil/not-specified
- name: data-node 		# String, non-empty, unique within requires
  type: data-node 		# String, non-empty, non-unique
```

### Deployment manifest schema

```yaml
name: proxy 								# String, non-empty

jobs:
- name: proxy
  templates:
  - name: proxy 						# String, non-empty, unique within templates, must exist within release
    release: cf-mysql 			# String, non-empty
  	consumes:               # Hash, optional
  	  data-node:            # String, non-empty, must exist within release job's consumes section
  	    from: my-data-node 	# String, non-empty, see link quilifiers
  	provides:               # Hash, optional
  	  data-node:            # String, non-empty, must exist within release job's consumes section
  	    as: my-data-node 		# String, non-empty, see link quilifiers
  	    shared: false 			# Bool, optional, defaults to false
```

### Link Qualifiers

Each link provided by a release job has a name. If the name is unique within a deployment it can be accessed by just `from: name`. Deployment operator can also specify `as: alt-name` in a provides section so that it can be accessed via `from: alt-name`.

Each provided link can be marked with shared: true or false. By default links are not shared so that consumers from other deployments cannot access other deployments' links. To allow other deployment to access link information, shared: true can be specified.

From field can be one of the following:

- `name` or `alt-name` can be used within deployment the same deployment
- `deployment.name` or `deployment.alt-name` can be used across deployments when link is shared

Once alt name is set via `as`, link can no longer be accessed via its name.

---
## Changes to Releases

To take advantage of links in releases, extra metadata needs to be specified: `consumes` and `provides` directives. Each deployment job that needs information about another job has to specify `consumes` with the name of the link type it consumes. Each deployment job that can satisfy link type has to specify `provides`. For example, in the MySQL release:

MySQL proxy job `spec`:

```yaml
name: proxy

consumes:
- {name: data-node, type: data-node}
```

MySQL node job `spec`:

```yaml
name: node

consumes:
- {name: data-node, type: data-node}

provides:
- {name: data-node, type: data-node}
```

OR

```yaml
name: node

consumes:
- {name: data-node, type: data-node}

provides:
- name: data-node
  type: data-node
  properties:
  - admin_user
  - admin_password
  - public_key
```

Proxy job consumes information about all nodes and each node job provides it. Also each node needs to know about other nodes, hence, node job consumes and provides node.

To access information provided by the link, release author would modify their ERB template. For example MySQL proxy job may do the following:

```yaml
nodes: <%= link("data-node").nodes %> # todo pick out IPs in a network?

# Link provided properties can be access like before: p, if_p, etc.
admin_user: <%= link("data-node").p("admin_user") %>
public_key: <%= link("data-node").p("public_key") %>
```

Link information contains following:

```yaml
{
	"nodes": [
		# For each one of the deployment job instances
		{
			"name": "data-node",
			"id": "4c213d80-05c1-429f-996f-8911854991a0",
			"index": 0,
			"az": "z1",
			"address": "10.0.0.44" || "0.private.data-node.deployment" || "IPv6"
		},
		{
			"name": "data-node",
			"id": "76009006-20c7-4cc0-b17d-134cf61226d2",
			"index": 1,
			"az": "z1",
			"address": "10.0.0.45" || "1.private.data-node.deployment" || "IPv6"
		}
	],

	"properties": {
		"admin_user": "admin-user",
		"admin_password": "some-secret",
		"public_key": "..."
	}
}
```

### Per-instance Links

Certain jobs expected to be colocated and the link information should only provide information about colocated jobs.

Given release configuration:

metron job `spec`:

```yaml
name: metron

provides:
- {name: metron, type: metron}
```

MySQL node job `spec`:

```yaml
name: node

consumes:
- name: metron
  type: metron
  colocated: true
```

And deployment manifest:

```yaml
jobs:
- name: node
  templates:
  - name: node
    release: cf-mysql
    consumes:
    	metron: {from: node_metron}
 	- name: metron
    release: loggregator
    provides:
    	metron: {as: node_metron}
```

metron link information will contain following:

```yaml
{
	"node": {
		"name": "data-node",
		"id": "bc82e8f9-3fcb-4728-a7d3-cfb3e6d94124",
		"index": 0,
		"az": "z1",
		"address": "10.0.0.44" || "0.private.data-node.deployment" || "IPv6"
	},

	"properties": {
		"admin_user": "admin-user",
		"admin_password": "some-secret",
		"public_key": "..."
	}
}
```

---
## Changes to Deployment Manifests

### Link Resolution

- multiple link types with the same name provided by different releases

	If deployment manifest contains different deployment jobs from different releases that provide `nats` link. Operator has to explicitly specify how a deployment job's link is provided. For example, assuming that node job consumes `nats` link:

	```yaml
	jobs:
	- name: node
	  templates:
	  - name: node
	    release: cf-mysql
	    consumes:
	    	nats: {from: other-nats} # ambigious cf's nats vs nats' natds job

	- name: nats
	  templates:
	  - name: nats
	    release: cf

	- name: other-nats
	  templates:
	  - name: natsd
	    release: nats
	    provides:
	    	nats: {as: other-nats}
	```

- multiple links of the same type (primary_db and backup_db links)

	Assuming that both links would consume same type of link consumes mechanism can be extended to support name vs type. For example:

	```yaml
	name: web
	consumes:
	- {name: primary_db, type: db}
	- {name: backup_db, type: db}
	```

	```yaml
	name: mysql-server
	provides:
	- {name: db, type: db}
	```

	And to use link by name:

	```yaml
	primary_db: <%= link("primary_db").nodes %>
	```

- links between deployments, assuming that shared: true is specified

	```yaml
	jobs:
	- name: node
	  templates:
	  - name: node
	    release: cf-mysql
	    consumes:
	      nats: {from: other-dep.nats}
	```

- custom provided links to external services (not controlled by the Director)

	```yaml
	jobs:
	- name: node
	  templates:
	  - name: node
	    release: cf-mysql
	    consumes:
	      nats:
	      	nodes: [{ ... }]
		    	properties: { ... }
	```

	- TBD: easier way to fill out link's nodes information for custom provided links (addresses: [...])

- links that only require access to a single collocated deployment job

### Address Resolution

Consumer of the link picks which network to use for addresses. If network is specified but cannot be found on the provider, error should be raised. Defaults exist for the following cases:

- nodes are on a single network

	Since there is only one network, it's chosen as a default.

  ```yaml
	jobs:
	- name: nats
	  templates:
	  - name: node
	    release: nats
	  networks:
	  - name: private
	- name: node
	  templates:
	  - name: node
	    release: cf-mysql
	    consumes:
	    	nats: {from: nats} # "private" network is picked
    networks:
	  - name: other-private
	```

- nodes are on multiple networks

	By default network marked with default=gateway is chosen.

	```yaml
	jobs:
	- name: nats
	  templates:
	  - name: node
	    release: nats
	  networks:
	  - {name: private, default: [dns]}
	  - {name: vip, default: [gateway]}
	- name: node
	  templates:
	  - name: node
	    release: cf-mysql
	    consumes:
	    	nats: {from: nats} # "private" network is picked since it's marked as default-for-gateway
    networks:
	  - name: other-private
	```

## Stories

[see links label in Tracker for created stories]

- user can reference another release job as link source even though it does not 'provide' anything []
  - naming for the link source?
  - only provide network information

## TBD

- validation of exposed properties on the link
- optionality of link requires
- do jobs with 0 instances provide empty nodes?
- how to enforce singular node link (metadata, ERB?)
