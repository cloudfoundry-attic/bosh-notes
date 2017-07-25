# Errands v2 [IN PROGRESS]

An errand is job that has `bin/run`.

There are several scenarios in which colocated errands (running on service instances) would be useful:

- backup errands
- recovery errands
- collect debugging information from colocated jobs
- speed up errand operations

## Manifest

```
instance_groups:
- name: credub
  lifecycle: service
  jobs:
  - name: credhub
    properties:
      ...
  - name: credhub-rekey # <------- errand on service instance
    properties:
      ...
  - name: credhub-rekey-1 # <------- errand on service instance
    properties:
      ...
  - name: credhub-rekey-2 # <------- errand on service instance
    properties:
      ...

- name: credub
  lifecycle: errand
  jobs:
  - name: credhub-rekey-dedicated # <------- errand
    properties:
      ...
```

## Director

$ bosh errands

lists errands

- list of errand jobs
- list of instance groups that have lifecycle=errand for backwards compatibility

$ bosh run-errand backup

runs errand of multiple errands

- may be ambigious between and instance group and a job
  - prefer job instead of an instance group
- runs all errands by name of backup in the deployment

$ bosh run-errand backup --instance group

run on all instances of an instance group

$ bosh run-errand backup --instance group/id

run on particular instance

$ bosh run-errand backup --instance name/any

run on one of the instances

## Agent API

- currently doesnt take any arguments
- update it to take in an argument of a job
- has to be backwards compatible with old agents

run_errand(job_name)

## TBD

- multiple instances
- parallel execution of errands in a deployment
- before/after during bosh deploy execution
- multiple errand results? vs multiple erran tasks enqueued?
