# Links Director API

Starting use cases for exposing links over an API:

- to visualize and help understand deployment topology [deployment]
- to visualize and help understand releases' metadata [release]
- to provide a way to access link's networking information for service brokers to include DNS in their bindings [deployment]

Recap: link structure is made of link consumer (LC), link itself (L) and link provider (LP). It's analogous to app, service binding and service instance.

```
+----+           +----+
|    |           |    |
|  +-+  +-----+  +-+  |
|  |    |  L  |    |  |
|  +-+  +-----+  +-+  |
| LC |           | LP |
+----+           +----+
```

Following endpoints would be exposed based on deployments:

```
GET /link_consumers?deployment=name
  desc: Returns available consumers in a deployment
  resp: [{
    id                   # internally "dep.ig.job.link-name"
    link_consumer_definition_id
  }]

GET /link_providers?deployment=name
  desc: Returns available providers in a deployment
  resp: [{
    id                   # internally "dep.ig.job.link-name"
    name                 # equivalent to "as" in the manifest
    shared               # determines who can consume (in/out of deployment)
    link_provider_definition_id
  }]

GET /links?deployment=name
  desc: Returns list of established links
  resp: [{
    id                   # internally "dep.ig.job.link-name" + "dep.ig.job.link-name"
    link_consumer_id
    link_provider_id
    network=string
    instances=[{...}]
    properties={...}
  }]

POST /links
  desc: Establishes a link between one consumer and one provider
  req: {
    link_consumer_id=null # if null means consumer is external
    link_provider_id
    network
  }
  resp: {
    id
    link_consumer_id
    link_provider_id
    network=string
    instances=[{...}]
    properties={...}
  }

DELETE /links/:id
  desc: Deletes given link
  resp: 200 OK

GET /link_instances?link_id=...
  desc: Returns list of instances within a link (equivalent in ERB: <%= link(...).instances.map { ... } %>)
  resp: [{
    address: ipv4|ipv6|dns-rec
    az
    index
    id
  }]

GET /link_address?link_id=...&az=z1...
  desc: Returns link's address (FQDN) (equivalent in ERB: <%= link(...).address(azs: [z1]) %>)
  resp: "q-i1a2.ig..."
```

Following endpoints could be exposed based on releases:

```
GET /link_consumer_definitions?release=...
GET /link_provider_definitions?release=...
```

One possible workflow for service broker to expose a link to an app:

- SB asks adapter for shared link name
- SB finds out link provider name within a deployment
  - `GET /link_providers?deployment=...` and pick one
- SB establishes a link
  - `POST /links` with {link_provider_id=<from prev step>; link_consumer_id=null; optionally network}
- SB now has a link ID, so it can retrieve DNS address
  - `GET /link_address?link_id=<from prev step>`
- SB provides link address to adapter

Possible workflow for a visualizer (CLI/Web):

- Retrieve all consumers, providers, and links
- Show formed links consumers paired up with providers
  - Cross reference by link_consumer/provider_ids
- Show consumers and providers not used in links
- Show location info for each? (job, instance group ...)
