- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

As an operator who deploys Director+UAA+Credhub, I expect deploy procedure to go as fast as possible.

# Motivation

In variety of cases, operators have to update Director VM and we would like to reduce downtime that update incurs. Following are typical scenarios for the update:

- update stemcell
- update releases
- reconfigure IaaS configuration for the Director VM
- enable colocated job (like syslog-forwarding)

# Details

...

Example of a create-env based on bosh-deployment on GCP:

```
step: creating bosh director
Deployment manifest: '/Users/pivotal/go/src/github.com/cloudfoundry/bosh-bootloader/ignored/make-gcp-fail/bosh-deployment/bosh.yml'
Deployment state: '/Users/pivotal/go/src/github.com/cloudfoundry/bosh-bootloader/ignored/make-gcp-fail/vars/bosh-state.json'
Started validating
  Downloading release 'bosh'... Skipped [Found in local cache] (00:00:00)
  Validating release 'bosh'... Finished (00:00:00)
  Downloading release 'bosh-google-cpi'... Skipped [Found in local cache] (00:00:00)
  Validating release 'bosh-google-cpi'... Finished (00:00:01)
  Downloading release 'os-conf'... Skipped [Found in local cache] (00:00:00)
  Validating release 'os-conf'... Finished (00:00:00)
  Downloading release 'uaa'... Skipped [Found in local cache] (00:00:00)
  Validating release 'uaa'... Finished (00:00:00)
  Downloading release 'credhub'... Skipped [Found in local cache] (00:00:00)
  Validating release 'credhub'... Finished (00:00:00)
  Validating cpi release... Finished (00:00:00)
  Validating deployment manifest... Finished (00:00:00)
  Downloading stemcell... Skipped [Found in local cache] (00:00:00)
  Validating stemcell... Finished (00:00:00)
Finished validating (00:00:02)
Started installing CPI
  Compiling package 'golang/b1d1bd861b0fc14b92e2a88fed01de017037f242'... Finished (00:00:00)
  Compiling package 'bosh-google-cpi/cb55944988bbbbb6e425e95ab17e859490ba7088'... Finished (00:00:11)
  Installing packages... Finished (00:00:02)
  Rendering job templates... Finished (00:00:00)
  Installing job 'google_cpi'... Finished (00:00:00)
Finished installing CPI (00:00:14)
Starting registry... Finished (00:00:00)
Uploading stemcell 'bosh-google-kvm-ubuntu-trusty-go_agent/3468.21'... Finished (00:00:56)
Started deploying
  Waiting for the agent on VM 'vm-d5500f36-38ee-4067-440f-78252973baf2'... Finished (00:00:01)
  Stopping jobs on instance 'unknown/0'... Finished (00:00:00)
  Unmounting disk 'disk-e2c66410-cfda-4db4-7cfc-172341b54361'... Finished (00:00:07)
  Deleting VM 'vm-d5500f36-38ee-4067-440f-78252973baf2'... Finished (00:02:33)
  Creating VM for instance 'bosh/0' from stemcell 'stemcell-238f6e2f-21f2-467f-6e7a-f2ef7b54f832'... Finished (00:00:37)
  Waiting for the agent on VM 'vm-e4b323c4-8e49-47b4-78ca-5ee46c39bbe9' to be ready... Finished (00:00:30)
  Attaching disk 'disk-e2c66410-cfda-4db4-7cfc-172341b54361' to VM 'vm-e4b323c4-8e49-47b4-78ca-5ee46c39bbe9'... Finished (00:00:18)
  Creating disk... Finished (00:00:03)
  Attaching disk 'disk-ba66b3d8-7c98-4635-7513-d010c07e4a5c' to VM 'vm-e4b323c4-8e49-47b4-78ca-5ee46c39bbe9'... Finished (00:00:20)
  Migrating disk content from 'disk-e2c66410-cfda-4db4-7cfc-172341b54361' to 'disk-ba66b3d8-7c98-4635-7513-d010c07e4a5c'... Finished (00:00:08)
  Detaching disk 'disk-e2c66410-cfda-4db4-7cfc-172341b54361'... Finished (00:00:10)
  Deleting disk 'disk-e2c66410-cfda-4db4-7cfc-172341b54361'... Finished (00:00:03)
  Rendering job templates... Finished (00:00:11)
  Compiling package 'openjdk_1.8.0/79f1f63caaa90ccb6e43861ac34a5aa5afb17ce8'... Skipped [Package already compiled] (00:00:03)
  Compiling package 'ruby-2.4-r3/8471dec5da9ecc321686b8990a5ad2cc84529254'... Skipped [Package already compiled] (00:00:02)
  Compiling package 'golang/b1d1bd861b0fc14b92e2a88fed01de017037f242'... Finished (00:00:43)
  Compiling package 'mysql/b7e73acc0bfe05f1c6cbfd97bf92d39b0d3155d5'... Skipped [Package already compiled] (00:00:02)
  Compiling package 'libpq/3afb51e921e950abb31e5d039d2144591a41482d'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'credhub/929572a392d431ce448016a80155712c8bec35ac'... Skipped [Package already compiled] (00:00:06)
  Compiling package 'postgres-9.4/52b3a31d7b0282d342aa7a0d62d8b419358c6b6b'... Skipped [Package already compiled] (00:00:01)
  Compiling package 'health_monitor/81dd0f6b874d009696027d43282893df4c18b2c8'... Skipped [Package already compiled] (00:00:01)
  Compiling package 'verify_multidigest/8fc5d654cebad7725c34bb08b3f60b912db7094a'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'bosh-google-cpi/cb55944988bbbbb6e425e95ab17e859490ba7088'... Finished (00:00:29)
  Compiling package 'uaa/30d4b4df159ff995fca84d22fc456dc99d6945a9'... Skipped [Package already compiled] (00:00:11)
  Compiling package 'bosh-gcscli/fce60f2d82653ea7e08c768f077c9c4a738d0c39'... Skipped [Package already compiled] (00:00:01)
  Compiling package 'postgres/3b1089109c074984577a0bac1b38018d7a2890ef'... Skipped [Package already compiled] (00:00:02)
  Compiling package 'lunaclient/b922e045db5246ec742f0c4d1496844942d6167a'... Skipped [Package already compiled] (00:00:01)
  Compiling package 'uaa_utils/20557445bf996af17995a5f13bf5f87000600f2e'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'gonats/866cdc573ac10dd85929abb531923197486ffa95'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'davcli/2672d0a96a775f5252fef6ac7bbab3928aa41599'... Skipped [Package already compiled] (00:00:00)
  Compiling package 's3cli/b6e38c619dd5575e16ea9fcabc4b7c500effdd26'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'director/06635593362c742ed6027270d6fbe0ddd8439650'... Skipped [Package already compiled] (00:00:03)
  Compiling package 'nginx/3518a530de39c41ec65abf1194c27aadae23b711'... Skipped [Package already compiled] (00:00:00)
  Updating instance 'bosh/0'... Finished (00:01:44)
  Waiting for instance 'bosh/0' to be running... Finished (00:01:41)
  Running the post-start scripts 'bosh/0'... Finished (00:00:19)
Finished deploying (00:11:00)
```

# Drawbacks

...

# Unresolved questions

...
