## OS Reload

One of the generic ways to speed up stemcell updates across a large number of VMs is to update the OS on the root partition (stemcell) instead of recreating an entire VM (through IaaS). We can introduce 'reload' as an optional strategy for `bosh deploy` and potentially even `bosh recreate` (if that's not too confusing).

Things we don't want to change:
* The Director knows nothing about stemcells, they're just blobs it passes on to the CPI. It therefore cannot extract the rootFS out of any given stemcell. Which would also be hard to do for light stemcells.
  * Therefore, we need something like 'generic (IaaS-independent) stemcells', i.e. a .tgz of the rootFS without any specific image format or other stuff that the user needs to upload
  * This also means, we won't be able to update agent-settings with this strategy. If those change, you're forced to recreate.
* `bosh cck` and resurrection need to create VM with the correct Stemcell versions. Therefore, users need to also have IaaS specific stemcells available before they can use the reload strategy

Pluses:
- speed: it's faster to download, extract, and reboot than to teardown the old VM and wait for a new VM
  - reboot on OpenStack takes 3 seconds, create VM takes 3.5 minutes
- reliability of updates: Public IaaS providers might have capacity problems for a specific instance type, which is annoying to realize in the middle of an update
- availability: you can still fix security updates, even if your IaaS cannot create new VMs for some reason
- can be done generically for all Linux OSes
  - Windows wont work

Minuses:
- downloading generic stemcell archive to each VM (~400mb) over IaaS network puts extra stress
- IaaS UI does not reflect which image is being used
  - Additional Metadata tags might be able to show the truth
- if machine is compromised then machine will remain to be compromised in certain cases
  - i.e. recreate in regular intervals might still be required, depending on personal security needs
- requires Director to keep generic stemcell in its blobstore

## Update Stemcell Workflow

1. Upload IaaS specific stemcell in version `v`
1. Make a deployment based on that stemcell
1. Upload new version `v'` of IaaS specific stemcell
1. Upload IaaS agnostic stemcell of version `v'`
1. Update stemcell version in manifest to `v'` and run deployment command with strategy 'reload'

## CLI changes

- roll out new stemcell to an existing deployment with a different deployed version
- roll out new stemcell to an existing deployment with a same deployed version
- recreate a machine based on IaaS stemcell

TBD:
- what's CLI experience bosh deploy commands to select which recreate strategy to use
- how does it relate to udpate strategy

```
$ bosh deploy manifest.yml --update-stemcell-strategy reload (default: recreate)
$ bosh recreate [x]        --update-stemcell-strategy reload
```
## Suggested Changes
* check viability of scenario
  * create release that downloads stemcell on a VM.
  * deploy on "production"
* agent changes (use above release for updating)
  * new agent method `update_rootfs(blobstore_id)` (TODO: is it really the id usually sent to the agent?)
    * put .tgz on ephemeral disk
    * unpack to some location
    * execute script from within .tgz
      * update kernel
      * write addition to initramfs
        * copy root file system over existing `/`
      * write new `/boot/grub/grub.cfg` and/or `/boot/grub/menu.lst`
        * using new kernel
        * executing initramfs extension
  * new agent method `reboot`
    * `shutdown -r now` VM
* director changes
  * new endpoint to upload rootfs.tgz
    * store in blobstore
  * add rootfs with version to list of /stemcells endpoint
  * agent call flow
    * send msg to agent `update_rootfs(blobstore_id)` to prepare
    * send `execute script: drain`
    * send `monit stop all`
    * send `reboot`
  * allow for `strategy: reload` key in deployments controller
    * ensure that stemcell and rootfs is there for a specific version
* CLI changes
  * `bosh upload-rootfs <.tgz> [--sha1 <sha1>]`
  * `bosh deploy [--strategy reboot]`, default recreate (as is of now)
  * `bosh stemcells` shows rootfs information
    * TODO: icon or column to show that a stemcell is 'rebootable'?
