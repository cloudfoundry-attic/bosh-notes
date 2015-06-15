# Compiled Releases

Currently a release consists of two parts: jobs and packages. Each job contains all the necessary metadata on how to start, stop, configure a process. Each package contains all the necessary *source code* needed to compile binaries and/or prepare source code to be used for running the process.

Releases can be compiled against a range of stemcells, but it does come at a cost of running compilation for each package on each different Director. To avoid paying package compilation cost each time someone is using a release on a specific stemcell somehow compilation output of each package must be shared.

## Solution

Instead of shipping releases that contain jobs and packages, ship releases that contain jobs and compiled packages for a specific stemcell version.

Advantages:

- does not rely on the internet just like a regular release
- does not require recompilation of everything for every stemcell [1]
- does not require shipping source code of packages
- does not require separate compiled bits for each IaaS

Disadvantages:

- cannot compile releases against arbitrary stemcell since source code is not included

Compiled packages are specific to:

- OS type (e.g. ubuntu-trusty, centos-7)
- OS version (stemcell version) (e.g. 2899)
- Arch (e.g. amd64, power)

Stemcells would have to include additional metadata about their OS type, OS version and architecture.

## Development Workflow

- CI builds a dev release (cf/192+dev.38444)
  - `bosh create release --version 192+dev.38444`
- CI uses the dev release with a specific stemcell version
- CI runs some tests
- CI exports release to produce a release tarball that only includes jobs and compiled packages
  - `bosh export release cf/193 ubuntu-trusty/2899 [--arch amd64]`
- CI promotes the dev release to be a final release (cf/193)
  - `bosh finalize release cf-192+dev.38444.tgz --version 193`

## Consumer Workflow

- Consumer uploads cf/193 that only contains compiled packages
  - `bosh upload release cf-193.tgz`
- Consumer uploads bosh-aws-xen-hvm-ubuntu-trusty-2899.tgz stemcell
- Consumer deploys (and given that their manifest is configured to use cf/193 and bosh-aws-xen-ubuntu-trusty/2899) no packages are compiled

## Stories

- user can see OS in the stemcell metadata for all stemcells (e.g. centos-7, ubuntu-trusty) [2]

- user can see OS when running `bosh stemcells` [4]
  - db migration: leave it as null
  - on upload stemcell: leave it as null if OS key not present
  - +-----------------------------------------+---------------+---------+--------------------+
	| Name                                    | OS            | Version | CID                |
	+-----------------------------------------+---------------+------------------------------+
	| bosh-aws-xen-hvm-ubuntu-trusty-go_agent | ubuntu-trusty | 2972    | ami-f0544998 light |
	| bosh-aws-xen-hvm-ubuntu-trusty-go_agent |               | 2971    | ami-f0544997 light |
  - n/a consistencey? -dk

- user can run export release command and see that args are validated and empty director task completes [2]
  - `bosh export release release-name/release-version (os type)/stemcell-version`
  - assumes that some deployment is targetted (for backwards compatibility / recovery)

- user sees an error before director task runs about the format of the release and stemcell refs [1]
  - validate format of the args for the CLI command (string with a slash in the middle)

- director task validates release presence on the director [2]
  - user sees an error from director task

- director task validates stemcell presence on the director [1]
  - user sees an error from director task when there is no stemcell that matches os/version criteria
  - DO NOT show error when there is more than one stemcell match

- user can run export release command and see that *all* non-compiled packages are compiled [4]
  - based on the rules of the targetted deployment
  - pick up the locks for the deployment, release and selected stemcell
  - select first stemcell based on OS and stemcell version
  - issue compile_package commands to the agent that were spawn up
  - does not aggregate anything into a tarball

- user sees an error if deployment is not set or deployment does not exist on the director [1]

- user can run export release command and see that tarball is made for the compiled release [4]
  - build up release.MF
  - save the compiled release into the blobstore as a tarball
  - include blobstore_id and sha1 in the export release task result

- user can run export release command and cli should automatically download exported release once director task completes [2]
  - look at the task result to find blobstore_id
  - use fetch_resource api call?
  - save a file into a current working directory called release-name-version-"on"-os-stemcell-version.tgz

## TBD

- should the compiled release have the same version as final release?
- who should produce compiled release and against which stemcell?
- should there be a stemcell criteria on the job instead of the resoure pool?
- how does user add source packages? (run bosh upload release with non-compiled release?)
- should bosh.io generate compiled releases?
- should compiled packages be shared just like source packages?
