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

## Proposed DB schema

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

Other possible uses:

- cross director linking
- link rotation (to rotate creds)
- operator consumed links


## Current API schema

...

## Proposed DB schema

```
link_providers:
    - `id`
    - `name`: Link Name (required)
    - Shared (required)

    - Deployment Id (should NOT be null) (required)
    - Consumable (boolean) (required) [to nil out provider]
    - Content (The full data that the link can provide) [examples???]

    - `link_provider_defintion_type`: Link Type (required) [comes from a release]
    - `link_provider_definition_name`: Link Original Name (required) [comes from a release]

    - `owner_object_name`: Provider Name (Job, Variable, Manual, etc.) (required) [for debugging]
    - `owner_object_type`: Provider Type (Job, Variable, Manual, etc.) (required) [for debugging]
    - `owner_object_info`: Metadata (The extra information used by visualization) [for debugging]

link_consumers:
    - `id`
    - `deployment_id`: Deployment the consumer belongs to (Can be null)

    - `link_consumer_defintion_type`: Link Type (required) [comes from a release]
    - `link_consumer_definition_name`: Link Original Name (required) [comes from a release]

    - `owner_object_name`: Provider Name (cloud_contoller, etc.) (required) [for debugging]
    - `owner_object_type`: Provider Type (Job, Variable, Manual, etc.) (required) [for debugging]
    - `owner_object_info`: Metadata (The extra information used by visualization) [for debugging]

links:
    - `link_provider_id`: Provider (Can be null when a link is orphaned)
    - `link_consumer_id`: Consumer
    - Link Contents (Each consumer type can have its own expected keys) [example???]
    - `created_at`: Created At
```

## Current DB schema

...
