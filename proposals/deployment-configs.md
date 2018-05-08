- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related proposals: [proposals/configs-api-v2-alt1.md](proposals/configs-api-v2-alt1.md)

# Summary
All configs associated with a deployments should be shown when displaying details about an individual deployment (e.g. with `bosh deployment -d <deployment name>`)

# Motivation
Currently, there is only information about one of the configurations: the cloud config. In the list of all deployments (i.e. `bosh deployments`), we show either `outdated` or `latest` in an individual column. We are missing a lot of information here, namely runtime config and config names plus IDs.

# Details
- `bosh deployment -d <deployment name>` should have a column that specifies referenced configs

```bash
$ bosh deployment -d dep1
Name  Release(s)  Stemcell(s)  Config(s)                    Team(s)
dep1  bosh-dns    bosh-...     123 cloud/default latest   team1
      ipsec                    124 runtime/default
                               125 runtime/ipsec
```

### API changes

* Introduce query parameter to exclude config information from list of deployments, as there are consumers which don't care about those `GET /deployments/:name?exclude_configs=true`
  * Switch BOSH HM to use this query parameter
* Introduce new API endpoint returning all configs associated with all deployments. Can be filtered for an individual deployment with a query parameter.
  * The new endpoint no longer includes the `latest`/`outdated` marker, just config IDs
```
GET /deployment_configs?deployment=dep1

[{id:"1", deployment:"dep1", config: {id:"123", type:"cloud", name:"default"}},
 {id:"2", deployment:"dep1", config: {id:"124", type:"runtime", name:"default"}},
 {id:"3", deployment:"dep1", config: {id:"125", type:"runtime", name:"ipsec"}}]

```

### CLI changes
* CLI uses new endpoint for `bosh deployment -d <dep1>`
* CLI removes `cloud config` column from `bosh deployments` and uses query parameter to exlude config information
...

# Drawbacks

...

# Unresolved questions

...
