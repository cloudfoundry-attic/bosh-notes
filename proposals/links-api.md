- State: in-progress
- Tracker: https://www.pivotaltracker.com/n/projects/2132440
- Tracker label: links-api
- Track anchors: slack: @asu @dwick

# Summary
Deployment links information should be exposed over an API.

# Motivation
Starting use cases for exposing links over an API:
- to visualize and help understand deployment topology [deployment]
- to visualize and help understand releases' metadata [release]
- to provide a way to access link's networking information for service brokers to include DNS in their bindings [deployment]

# Details
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

## Proposed API
<details><summary>Iteration 1</summary>

Following endpoints would be exposed based on deployments:

### Deployment specific
#### Providers

To get a list of providers within a deployment:
```
GET /link_providers?deployment=name
  desc: Returns available providers in a deployment
  resp: [{
    id                   # internally "dep.ig.job.link-name"
    name                 # equivalent to "as" in the manifest
    shared               # determines who can consume (in/out of deployment)
    link_provider_definition_id
  }]
```
---
#### Consumers

To get a list of consumers within a deployment:
```
GET /link_consumers?deployment=name
  desc: Returns available consumers in a deployment
  resp: [{
    id                   # internally "dep.ig.job.link-name"
    link_consumer_definition_id
  }]
```
---
#### Links

To get a list of links created by deployment:
```
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
```

To create a new link as an external consumer:
```
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
```

To delete a link:
```
DELETE /links/:id
  desc: Deletes given link
  resp: 200 OK
```

To get details exposed by the link:
```
GET /link_instances?link_id=...
  desc: Returns list of instances within a link (equivalent in ERB: <%= link(...).instances.map { ... } %>)
  resp: [{
    address: ipv4|ipv6|dns-rec
    az
    index
    id
  }]
```

To get network information about a link (with filtering):
```
GET /link_address?link_id=...&az=z1...
  desc: Returns link's address (FQDN) (equivalent in ERB: <%= link(...).address(azs: [z1]) %>)
  resp: "q-i1a2.ig..."
```
---
### Release specific
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
</details>

<details><summary>Iteration 2</summary>

### Deployment specific
#### Providers

To get a list of providers within a deployment:
```
GET /link_providers?deployment=name
```
Sample response:
```JavaScript
[
  {
    "id": 1,
    "name": "foo",
    "shared": true,
    "deployment": "deployment_foo",
    "link_provider_definition": {
      "name": "original_foo",
      "type": "bar",
    },
    "owner_object": {
      "name": "job_foo",
      "type": "Job",
      "info": {
        "instance_group": "provider_ig"
      }
    }
  }
]
```
---
#### Consumers

To get a list of consumers within a deployment:
```
GET /link_consumers?deployment=name
```
Sample response:
```JavaScript
[
  {
    "id": 1,
    "deployment": "deployment_bar",
    "owner_object": {
      "name": "job_bar",
      "type": "Job",
      "info": {
        "instance_group": "consumer_ig"
      }
    }
  }
]
```
---
#### Links

To get a list of links created by deployment:

```
GET /links?deployment=name
```
Sample Response:
```JavaScript
[
  {
    "id": 1,
    "name": "foobar", // This is the original name from consumer definition
    "link_consumer_id": 2,
    "link_provider_id": 3,
    "created_at": "Jan 20 1890 15:42:75 +500"
  }
]
```

To create a new link as an external consumer:
```
POST /links
```
Sample request:
```
TBD
```

To delete a link:
```
DELETE /links/:id
```

```
200 OK
```

To get details exposed by the link:
```
GET /link_instances?link_id=...
```
Note: Returns list of instances within a link (equivalent in ERB: `<%= link(...).instances.map { ... } %>`)
```
TBD
```

To get network information about a link (with filtering):
```
GET /link_address?link_id=...&az=z1...
```
Note: Returns link's address (FQDN) (equivalent in ERB: `<%= link(...).address(azs: [z1]) %>`)
```
TBD
```

</details>

## Current API schema
There are no API endpoints for accessing links information.

## Current DB schema
### How are links stored?
Let's talk about the providers first. When we have a someone providing the link, that information is only kept in memory at the time of resolving the links; thus not stored anywhere. There is one exception to that rule, cross deployment links. The details for cross deployment links are stored in the `deployments` table under the column `link_spec_json`.

"What about consumers?" You ask. Consumers are stored individually per instance in a column called `spec_json` in the `instances` table. In the way it's currently implemented, each consumer is an instance. The information stored is required for rendering a template successfully.

<details><summary>Example `link_spec_json`</summary>

```Javascript
...
```

</details>

<details><summary>Example `spec_json`</summary>

```JavaScript
{
  "deployment": "consumer-simple",
  // ...other information about this instance...
  "links": {
    "consumer": { // Consumer job name
      "provider": { // Link name to be consumed as specified by the release job
        "default_network": "a", // Network to expose from each providing instance
        "deployment_name": "simple", // Provider's deployment name
        "domain": "bosh",
        "instance_group": "foobar", // Instance group from provider deployment
        "instances": [{ // Instances within the providing instance group
          "name": "foobar",
          "id": "1a7c2a7b-9d8a-4cf6-8471-1304f26e46c6",
          "index": 0,
          "bootstrap": true,
          "az": null,
          "address": "192.168.1.2"
        }],
        "networks": ["a"], // List of all available network definitions
        "properties": { // Properties exposed by the link
          "a": "default_a",
          "b": null,
          "c": "default_c",
          "nested": {
            "one": "default_nested.one",
            "three": null,
            "two": "default_nested.two"
          }
        }
      }
    }
  }
}
```

</details>

## Proposed DB schema


### Providers (`link_providers` table)
| name | type | required? | description |
|---|---|---|---|
| `id` | Integer | yes | Unique identifier for each provider |
| `name` | String | yes | Alias specified by `as` in manifest; otherwise original name from release job |
| `shared` | Boolean | yes | Provider can be consumed by another deployment/external |
| `deployment_id` | Integer | yes | Deployment id of provider deployment (Foreign key of `deployments` table) |
| `consumable` | Boolean | yes | Usually true, only false when feature to nil out providers is implemented. (https://www.pivotaltracker.com/story/show/151894692) |
| `link_provider_definition_type` | String | yes | Type specified in the release job |
| `link_provider_definition_name` | String | yes | Original name specified in the release job |
| `owner_object_name` | String | yes | Name of the provider owner (eg. Name of job) |
| `owner_object_type` | String | yes | Type of the provider owner (eg. Job, Instance group) |
| `content` | String | yes | The full set of properties provided by the provider |


### Consumers (`link_consumers` table)
| name | type | required? | description |
|---|---|---|---|
| `id` | Integer | yes | Unique identifier for each provider |
| `deployment_id` | Integer | no | Deployment id of consumer; Deployment id of provider if external (Foreign key of `deployments` table) |
| `instance_group` | String | no | Instance group this consumer belongs to; Null if the consumer is external |
| `owner_object_name` | String | yes | Name of the consumer owner (eg. Name of job) |
| `owner_object_type` | String | yes | Type of the consumer owner (eg. Job, Instance group) |


### Links (`links` table)
| name | type | required? | description |
|---|---|---|---|
| `id` | Integer | yes | Unique identifier for each provider |
| `name` | String | yes | Name of the consumer owner (eg. Name of job) |
| `link_provider_id` | Integer | no | Id of the provider (Foreign key of `link_providers` table) |
| `link_consumer_id` | Integer | yes | Id of the consumer (Foreign key of `link_consumers` table) |
| `link_content` | String | yes | Content shared by the provider or manual link's definition |
| `created_at` | Time | yes | Time this link was created |
