- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Users should be able to view full diff of their changes without affecting currently running system. Diff should include details such as VM, disk recreation, new versions of releases, etc.

# Motivation

Operators want to see the impact of their changes on the running system from which they can estimate downtime, perf changes, available capacity (eg not enough diego cells), etc.

# Details

## First cut

First cut at this involves exposing instance changes (based on existing changes computation in the Director [1]):

- dirty?
- restart_requested?
- recreate_requested?
- cloud_properties_changed?
- stemcell_changed?
- env_changed?
- network_changed?
- packages_changed?
- persistent_disk_changed?
- configuration_changed?
- job_changed?
- state_changed?
- dns_changed?
- trusted_certs_changed?

[1] https://github.com/cloudfoundry/bosh/blob/b2fdc44b38e36cc9cff6582c8252952a0e768fdc/src/bosh-director/lib/bosh/director/deployment_plan/instance_plan.rb#L63-L76

CLI will be using task result output (user can look at it via `bosh task X --result`) to receive diffing information and showing it when `bosh deploy --dry-run` is used:

```json
{
  // list of configs used by this deploy
  "configs": [...]

  // existing text diff
  "diff": [
    ["...", "added"],
    ["...", "removed"]
  ],

  "impact": {
    "instances": [{
      "name": "...",
      "id": "...",
      "summary": "...",
      "changes": [
        {"type": "dirty"},
        {"type": "restart", "summary": "..."}
      ]
    },{
      "name": "...",
      "id": "...",
      "summary": "...",
      "changes": [{"type": "state", TBD deleted}]
    }],
    
    // possible refinements additions
    
    "networks": [{
      // TBD networks being created
    }],
    
    "instance_groups": [{
      // TBD general instance groups summary
    }]
    
    "deployments": [{
      // TBD general deployment summary
    }]
  }
}
```

Notes:

- cloud and runtime configs changes are reflected through instance changes
- persistent disk migrations are reflected through instance changes

To make other commands "diff-able" `--dry-run` flag should be added to recreate, restart, start, stop commands.

## Second cut

TBD:

- figure out how to deal with links across deployments.
- how does one revert portion of changes and see impact summary?
- what should API show while changes are "staged"
- should we have `bosh clean-up --staged` to release "staged" IPs

Sample workflow for users that may want to determine set of changes across multiple configs:

```
# Deletes previously staged changes
$ bosh delete-config --staged

# Add a config to the stage area
$ bosh update-config file.yml --type cloud      --name custom --stage
$ bosh update-config file.yml --type deployment --name cf     --stage

# Returns change set for the deploy
$ bosh -d cf1    deploy --dry-run --staged
$ bosh -d kafka1 deploy --dry-run --staged
$ bosh -d kafka2 deploy --dry-run --staged

# If wanted, to clean up staged changes
$ bosh delete-config --staged
```

* Using `--stage` instead of `--dry-run` for now

# Drawbacks

...

# Unresolved questions

- how to diff when multiple configs are changing (cloud, runtime, multiple deployments, etc.)
  - should we add --dry-run to update-config and friends
- better name for "delta" (changes, plan, ...)?
- should we include ability for release authors to provide customizable summaries
  - does this play in with automatically returned release notes?
