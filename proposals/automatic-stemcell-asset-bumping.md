- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Versioned assets which go into stemcells should be recorded in a permanent audit
trail, and less vulnerable to developer error when bumping in new stemcell versions.

This proposal describes a flow to automate the new version information to be
robustly committed to a permanent record & pulled into the Stemcell Builder
as part of CI.

# Motivation

Presently, in order for a new OS Image version to be pulled into a stemcell,
manual steps to bump the asset in stemcell builder are required. This is both
time-intensive and vulnerable to developer error/typos.

Other assets, such as bosh-agent, are pulled in and versioned in a totally
separate flow, which also involves committing changes to the bosh-linux-stemcell-builder.

Furthermore, there is no consolidated location for all source assets to be
version-grouped for a particular stemcell line/version; as auditors, we need
a permanent, source-controlled location where we can view what versions of each
asset (and the stemcell-builder source) went into any stemcell in history. That
record can be maintained by a system that is easy to understand and standardize,
such as meta4.

BOSH devs must go through this flow:
- Trigger a build to begin OS image building/testing. [the base OS image is automatically discerned and used.]
- After the pipeline publishes OS image tarballs, copy the version strings and SHAs of the assets out of Concourse UI.
- For bosh-agent changes, they must copy URLs and SHAs out of the bosh-agent pipeline.
- Commit those asset metadata and a comment to stemcell builder in appropriate place, which depends on the asset.

To audit a stemcell version, we have to look at the Concourse to see what commit built it;
in there, we look at the agent stage apply.sh, and the os_image_versions.json;
also in there, the OS_IMAGES.md file to determine the git SHA that an os image was built from;
we must look at that commit, then to see what OS image stages looked like at the time.

# Details

We propose to introduce a file like `bosh-linux-stemcell-builder/stemcell_builder/blobs/manifest.yml`:

    ---
    assets:
    - bosh-agent:
	version: 2.3.1
	url: <s3 download url>
	sha: a1b2c3
	git_sha: 1234abcd
    - ubuntu-trusty-os-image.tgz:
	version:
	url:
	sha:
    - centos-7-os-image.tgz:
	version:
	url:
	sha:

This file contains the versions that a stemcell built from this point in history contained.
The stemcell-builder would be able to download & checksum each of these assets,
and steps would be able to find them in a name-addressable assets directory that
they all share.

When a pipeline, such as bosh-agent pipeline, generates a new asset, it can use
meta4 to update a list of published versions and checksums. For new OS images,
that list may be maintained in this repo as an alternative to the hereafter-defunct
`OS_IMAGES.md`.

If we wish to automate building of new stemcells with changes to bosh-agent or os images,
we can detect new versions of such a list and trigger builds which bump this manifest.

# Drawbacks

Our manual commit process allows us to leave comments about each os-image bump in
`OS_IMAGES.md`. That would no longer be feasible if the process is entirely automated.

# Unresolved questions

can or should we automatically detect new OS image versions via a Concourse resource?
- if so, should we automatically trigger new builds?
- can we audit the changes/diff between automatically detected versions?

can this process help prevent stemcell-only changes from triggering new OS Image builds?
and vice-versa?

# Alternative

```
[bosh-agent]
  # aggregate artifacts and commit to an orphan branch 
  [build] -> @artifacts/{branch}/v1.2.3.meta4

^^^^^^
separate products, separation of concerns
vvvvvv

[bosh-linux-stemcell-builder]
  
  [watches bosh-agent ((branch))] -> @{branch}/assets/agent.meta4
  [build-os-image] -> @{branch}/assets/{OS_IMAGE}.meta4
  [stemcell]
    [os-image]
      filedownloader.rb -> meta4 file-download assets/{OS_IMAGE].meta4
    wget s3/bosh-agent-linux-amd64 -> meta4 file-download bosh-agent-*-linux-amd64
```
