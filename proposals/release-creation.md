- State: finished

# Release Creation

Focus of this document is to streamline scripting and usage of BOSH CLI and releases in the CI environments.

## Developer with manual final release publishing

```
# Change some code

[dev] bosh create release
Release version: 4+dev.1

[dev] bosh upload release
[dev] bosh deploy

# Run some tests (bosh run errand acceptance-tests?)

# Consider current version to be good
[dev] git commit -am 'fixed blah'

[dev] bosh finalize release
Release version: 5

# Publish final release with everyone
[dev] git commit -am 'Version 5'
[dev] git push origin master
```

## Developer + CI with explicit version management (e.g. Concourse)

```
# Change some code

[dev] bosh create release
Release version: 4+dev.1

[dev] bosh upload release
[dev] bosh deploy

# Run some tests (bosh run errand acceptance-tests?)

# Consider current version to be good
[dev] git commit -am 'fixed blah'
[dev] git push origin develop

# CI picks up changes and creates a dev release
# RC_VER and FINAL_VER include full version
[ci] bosh create release --with-tarball --version $RC_VER
Release tarball: name-$RC_VER.tgz

# CI uploads and runs tests
[ci] bosh upload release *.tgz
[ci] bosh deploy
[ci] bosh run errand acceptance-tests

# CI finalizes release
[ci] bosh finalize release *.tgz --version $FINAL_VER
[ci] git commit -am 'Version $FINAL_VER'
[ci] git push origin master
```

## Developer + CI without explicit version management (e.g. Jenkins)

```
# Change some code

[dev] bosh create release
Release version: 4+dev.1

[dev] bosh upload release
[dev] bosh deploy

# Run some tests (bosh run errand acceptance-tests?)

# Consider current version to be good
[dev] git commit -am 'fixed blah'
[dev] git push origin develop

# CI picks up changes and creates a dev release
# Assumes that BUILD_NUM is always incrementing
[ci] bosh create release --with-tarball --build 0+ci.$BUILD_NUM
Release tarball: name-0+ci.$BUILD_NUM.tgz

# CI uploads and runs tests
[ci] bosh upload release *.tgz
[ci] bosh deploy # Uses 0+ci.$BUILD_NUM
[ci] bosh run errand acceptance-tests

# CI finalizes release and assigns it the next final version
[ci] bosh finalize release *.tgz
Release version: name-5.tgz

[ci] git commit -am 'Version 5'
[ci] git push origin master
```

## `finalize release` options

- if --name is specified use given name
- if --name is not specified, use name used in the tarball
- if --version is specified use given version
- if --version is specified and is already taken, show an dup ver error
- if --version is not specified, follow BOSH bumping semantics (next biggest final version for that release name)
