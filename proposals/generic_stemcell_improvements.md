State: discussing
Start date: ?
End date: ?
Docs: ?

# Summary
This proposal is used to keep track of generic improvements to the stemcells and stemcell building code

# Motivation
There are numerous minor improvements that could be made to stemcell building, and having a place to track and record such improvements would be beneficial.

# Details
- Reorganize and update docs in `bosh-linux-stemcell-builder`. The documentation primarily consists of a lengthy [top-level README](https://github.com/cloudfoundry/bosh-linux-stemcell-builder/blob/master/README.md) The information in that document should be verified and reorganized into separate files; other documentation files in the repo should undergo the same procedure.
- Make stemcell and os image build output quieter; much of the current output is not useful, and the volume causes builds to load slowly when viewing them on Concourse.
- Stemcell tests should not mount and unmount the built image to a loopback device for every test. Doing so adds time without providing any meaningful benefit.
- Create rake tasks for running the stemcell builder units, stemcell tests, os-image tests, and shellout type tests. Currently, running those tests requires locating RSpec commands in the code/documentation, manually performing any necessary setup, and then running the command by hand. Such a testing procedure slows down iteration.
- Organize the builder stages into `os-image` and `stemcell` directories, based on which build task uses them. Having the stages organized more clearly according to their purpose will allow the Concourse pipelines to be more accurate about when builds should be triggered; reorganization will also help with overall clarity.
- Remove unused files and directories.
- Remove VMWare copyright lines
- Fix creation of `build` and `work` directories in `bosh-stemcell` so that their paths are not doubled (e.g, should appear as `warden/boshlite/ubuntu/trusty/work` instead of `/warden/boshlite/ubuntu/trusty/work/work`.
- Consider moving the included `bosh-dev` code into `bosh-stemcell` itself; the number of files it's using does not seem to justify the dependency on bosh-dev. Additionally, some of the `bosh-dev` code may only be used by outdated code paths.
- The .vmx file in vSphere stemcells should accurately reflect the stemcell's operating system. It currently hardcodes the OS name to `ubuntu`.
- Audit `config.sh` files in stemcell builder stages. In several cases the config files are anemic or entirely unnecessary.

# Drawbacks
...

# Unresolved questions
...
