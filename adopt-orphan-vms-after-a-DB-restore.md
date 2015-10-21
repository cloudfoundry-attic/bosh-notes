# Adopt orphan vms after a DB restore

Consider the following disaster recovery scenario: 

1. Run a `bosh backup` to backup bosh director database
2. Start a bosh deploy that creates a consistent bunch of new vms (for example new DEAs for a CF release)
3. While the deploy is running or in any case before a new backup is taken, a disk corruption occurs

Currently the bosh administrator can recover by restoring the DB from the backup; anyway the newly created vms are not referenced in the DB.
What he can do is to run again a `bosh deploy`/`bosh cloudcheck` and create again the vms. Then he must identify and delete the orphan ones.

The drawback of this approach is that the orphans vms are already known to the deployed env. In the DEAs example, the orphan DEAs could already be hosting customer applications. Basing on the role of the VM, additional procedure could be necessary before safely delete it. 

In order to improve the bosh administrator experience in managing this disaster recovery scenario and to minimize the impact on customers, we propose to add to the BOSH Director and to the underlying CPI the possibility to adopt a list of vms:

```
bosh vmsadopt <cids_file> [<deployment_name>] [--auto] [--report]
    Inspect orphan vms provided in input and interactivly adopt in the deployment
	cids_file contains a list of cids for the orphan vms to adopt. It can be a local file or a remote URI.
    --auto            adopt vms automatically (not recommended for production)
    --report          generate report only, don't attempt to adopt vms
```

When a user runs a `bosh vmsadopt` command, bosh must:
1. Run a cloudcheck to find out missing vms
2. For each vm provided in input, connect to it and inspect the `spec.json`
3. Search for a match among the missing vms
4. If it finds a match, propose to adopt the orphan vm
5. If it doesn't find a match with any missing vm, propose to delete the orphan vm
