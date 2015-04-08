# BOSH Environment Configuration

Below are the steps that show how BOSH environment configuration may evolve. (Assuming that `bosh-init` and bosh CLI merge into one CLI.)

1. Create new directory to hold some BOSH env:

	```
	$ mkdir -p envs/staging
	$ cd envs/staging
	```

2. Describe IaaS specific configuration:

- includes networking, resource pools, disk pools, etc.
- includes CPI configuration?

	```
	$ vim cloud.yml
	```

3. Initialize BOSH environment

- creates/migrates bosh.yml that holds configuration for the Director
- init assumes that cloud.yml is in the current directory
- pull

	```
	$ bosh init
	Initializing/updating 'staging' environment...
	```

4. Continue to use the created/updated environment

	```
	$ bosh target X
	$ bosh stemcells
	$ bosh update cloud-config?
	$ bosh deploy ...
	```

5. Destroy whole BOSH environment

	```
	$ bosh deinit
	About to destroy 'staging' environment [y/n]?
	```

TBD: should user run `update cloud-config` vs running `init`?
TBD: rely on directory structure that contains cloud.yml and bosh.yml?
TBD: cd into directory or pass it as a param?
TBD: does destroy environment just delete the BOSH VM or does it call `destroy_environment` CPI call?
