- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related proposals: [proposals/configs-api-v2-alt1.md](proposals/configs-api-v2-alt1.md)

# Summary

Director user should see deployment manifests in configs view (`bosh configs` command). Manifests should be referenced by an id by the deployment, similarly to how runtime and cloud configs are referenced.

# Motivation

It's important to consolidate deployment manifest and other config concepts into a single API and UX. By using configs API to store deployment manifests, users will gain consistent visibility which configurations contribute to the deployment.

# Details

- `bosh -d dep1 manifest` should return content of the reference deployment config
- `bosh deployments` should have a column that specifies referenced configs

```bash
$ bosh deployments
Name  Release(s)  Stemcell(s)  Config(s)                    Team(s)
dep1  bosh-dns    bosh-...     122 deployment/dep1 latest   team1
      ipsec                    123 cloud/default latest
                               124 runtime/default
                               125 runtime/ipsec
dep2  bosh-dns    bosh-...     126 deployment/dep2 latest   team2
      ipsec                    123 cloud/default latest
                               124 runtime/default
                               125 runtime/ipsec
```

- update deployment event should record before and after configs

# Drawbacks

- `latest` identifiers will continue to remain latest

# Unresolved questions

- which parts of the Director rely on previously saved version of a deployment manifest
