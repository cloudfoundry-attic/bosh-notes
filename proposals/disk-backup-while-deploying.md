- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

As a Director user, I expect that disks are copied while deploy is happening so that I'm sure new version of software I'm deploying does not corrupt my data (and I have a way to recover).

# Motivation

Recently several users struggled with Concourse upgrades. It would have been nice to enable this funcitonality so that Concourse user can always fall back and use older disk copy.

# Details

One of the ideas is to force Director to "migrate" disk for instances that have persistent disks.

# Drawbacks

...

# Unresolved questions

...
