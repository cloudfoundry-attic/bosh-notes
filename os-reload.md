## OS Reload

One of the generic ways to speed up stemcell updates across large number of VMs is to update OS on root partition (stemcell) instead of recreating an entire VM (thru IaaS).

Pluses:

- does not depend on speed/availability/capacity of IaaS during stemcell update
  - todo record sample times
- can be done generically for all Linux OSes
  - Windows wont work

Minuses:

- downloading stemcell archive to each VM (~400mb) over IaaS network puts extra stress
- IaaS UI does not reflect which image is being used
- if machine is compromised then machine will remain to be compromised
- requires Director to keep generic stemcell in its blobstore

## Workflow

1. upload IaaS specific stemcell initially
1. make a deployment based on that stemcell
1. upload IaaS agnostic stemcell (of same or different version)
1. run deployment command that uses IaaS agnostic stemcell

## CLI changes

- roll out new stemcell to an existing deployment with a different deployed version
- roll out new stemcell to an existing deployment with a same deployed version
- recreate a machine based on IaaS stemcell
- recreate a machine based on generic stemcell (without IaaS interaction)

TBD:
- what's CLI experience bosh deploy commands to select which recreate strategy to use
- how does it relate to udpate strategy

```
$ bosh deploy manifest.yml --update-stemcell-strategy reload (default: recreate)
$ bosh recreate [x]        --update-stemcell-strategy reload
```

## Director changes

- Director should allow Agent to download generic stemcell without stopping its current workload
- Director issues reload Agent call after download has succeeded and after workload is terminated

## Agent changes

- action to download generic stemcell
  - download destination should be ephemeral disk
- action to reload OS based on downloaded stemcell
  - replaces / with upacked downloaded stemcell (without messing up running system)
  - hard-reboots machine
