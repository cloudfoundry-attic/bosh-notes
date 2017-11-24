- State: in-progress

# Summary

Tracking user features and specific code that needs to be deprecated. Permanently `in-progress`.

# Details

- ~`bosh public stemcells` CLI commands~
- ~`bosh create/delete user` CLI commands~
  - remove users database table
- `template` key on deployment job
- old-style dev version suffix in Bosh::Common::Version::ReleaseVersion
- `prepare_network_change`, `configure_networks`, `prepare_configure_networks` from agent actions
- `bosh cleanup` should not fall back to old director delete stemcell and delete release endpoints when old director is encounterd with new cli
- resource pool
- networks['network_name']['dns_record_name'] in job templates 
- remove dependency key munging inside update_release
