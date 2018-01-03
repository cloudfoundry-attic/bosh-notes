- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

CLI v2 should support Windows for release mgmt and Director operations (such as ssh and scp).

# Motivation

...

# Details

## External dependencies
- bosh-cli
  - bash
    - [cloud/cpi_cmd_runner.go](https://github.com/cloudfoundry/bosh-cli/blob/master/cloud/cpi_cmd_runner.go#L87)
    - [installation/pkg/compiler.go](https://github.com/cloudfoundry/bosh-cli/blob/master/installation/pkg/compiler.go#L95)
    - [release/resource/archive.go](https://github.com/cloudfoundry/bosh-cli/blob/master/release/resource/archive.go#L112)
  - /dev/null
    - cmd/temp_root_configurator_test.go [`returns an error if changing the temp root fails`](https://github.com/cloudfoundry/bosh-cli/blob/master/cmd/temp_root_configurator_test.go#L75) [`returns an error if changing the temp root fails`](https://github.com/cloudfoundry/bosh-cli/blob/master/cmd/temp_root_configurator_test.go#L94)
    - [ssh/ssh_args.go](https://github.com/cloudfoundry/bosh-cli/blob/master/ssh/ssh_args.go#L63)
    - [ssh/ssh_args_test.go](https://github.com/cloudfoundry/bosh-cli/blob/master/ssh/ssh_args_test.go)
- bosh-utils
  - tar
    - fileutil/tarball_compressor.go [`CompressSpecificFilesInDir`](https://github.com/cloudfoundry/bosh-utils/blob/master/fileutil/tarball_compressor.go#L40) [`DecompressFileToDir`](https://github.com/cloudfoundry/bosh-utils/blob/master/fileutil/tarball_compressor.go#L54)

### bash
Path | Windows API | Cygwin bash | MSYS2 bash | Windows Subsystems for Linux bash
-----|--------------|---------|--------|---------
/Windows/Temp/foo | valid (&ast;) | invalid | invalid | invalid
/c/Windows/Temp/foo | invalid | invalid | valid | invalid
/mnt/c/Windows/Temp/foo | invalid | valid | invalid | valid
C:\Windows\Temp\foo | valid | valid | valid | invalid

&ast; if current path is on C drive

bash version | uname | Inherits Environment Variables
-------------|-------|------------------------------
Cygwin | CYGWIN_NT-10.0 | Yes
MSYS2 | MSYS_NT-10.0 | Yes
Windows Subsystems for Linux | Linux | No (&ast;)

&ast; To set environment variables when calling Windows Subsystems for Linux, set them inside of bash, e.g. using [`export`](https://github.com/Fydon/bosh-cli/blob/feature/CompileOnWindows/installation/pkg/compiler.go#L106-L117).

### tar
Path | Windows API | BSD Tar | MSYS2 Tar
-----|--------------|---------|--------
/Windows/Temp/foo | valid (&ast;) | valid | invalid
/c/Windows/Temp/foo | invalid | invalid | valid
C:\Windows\Temp\foo | valid | valid | invalid

&ast; if current path is on C drive

Taken from charlievieth post about tar [here](https://github.com/cloudfoundry/bosh-utils/pull/11#issuecomment-280207185)

### Thoughts
- bash
  - Would it be possible to have all BOSH Releases' packaging script have a bash script and something else, e.g. a PowerShell Core script? This would eliminate the need for bash on Windows and the difference between the various versions of bash on Windows.
  - In order to overcome the path differences of local paths, it is possible to call `pwd` before the command to find out what the base path will be, e.g. as shown [here](https://github.com/cloudfoundry/bosh-cli/pull/322/files#diff-1dc86b4d50c5fba5d1433234d1a73c56R93).
- tar
  - Could be replaced by using Golang libraries instead, e.g. [archiver](https://github.com/cloudfoundry/archiver). This wouldn't solve all cases as, mentioned in [this Slack conversation](https://cloudfoundry.slack.com/archives/C02PW344Y/p1496928072290172), not everything that uses tar is in Golang, e.g [windows_app_lifecycle's packaging script](https://github.com/cloudfoundry/diego-release/blob/develop/packages/windows_app_lifecycle/packaging). However there may be an alternative way to eliminate tar from those cases, e.g. that packaging script is probably only using tar directly because it isn't being processed by bosh-cli's `create-env`.

## How to execute a file
- Linux uses the first line of the shell script
- Windows uses the file extension, where a file without an extension can't be assigned a program and the user will be prompted to select a program to use to process the file.
### BOSH Releases
- Linux
  - The packaging scripts are currently all [bash scripts](https://github.com/cloudfoundry/bosh-cli/blob/master/installation/pkg/compiler.go#L95).
- Windows
  - `create-env` isn't working on Windows yet, but there are PowerShell packaging scripts, e.g [golang](https://github.com/bosh-packages/golang-release/blob/master/packages/golang-1.8-windows/packaging).
### Thoughts
- If Windows does need to be able to run shell scripts, then ideally git repositories would be set up to explicitly have all shell scripts have LF as the line ending. This could be done in the following ways:
  - Renaming all scripts to have a .sh extension and adding a `.gitattributes` file with `*.sh text eol=lf`
  - Adding a `.gitattributes` file listing all shell scripts as having a line ending as LF

# Known issues
- bosh-cli
  - commands
    - `create-env` fails when it reaches the `Updating instance` part of `Started deploying`
    - `interoplate`'s `--path` flag fails in tests
  - tests failing
    - acceptance/lifecycle_test
    - cmd/temp_root_configurator_test.go
    - integration/upload_release_test.go
    - integration/sha1ify_release_test.go
    - integration/interpolate_test.go
    - release\resource\archive_test.go
    - releasedir/fs_release_dir_test
    - templatescompiler/erbrenderer/erb_renderer_test
- bosh-utils
  - tests failing
    - fileutil/generic_cp_copier_test.go
    - fileutil/tarball_compressor_test
    - system/os_file_system_test.go
    - system/os_long_path_test
    - system/exec_cmd_runner_test

# Drawbacks

...

# Unresolved questions

...
