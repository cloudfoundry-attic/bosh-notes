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

Example #1:

- bosh-deployment on GCP

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

Example #2:

- opsman is 2vCPUs and 7.5GB RAM on GCP
- note slow 'Rendering templates' stage

```
Started validating
  Validating release 'bosh'... Finished (00:00:03)
  Validating release 'bosh-google-cpi'... Finished (00:00:08)
  Validating release 'uaa'... Finished (00:00:08)
  Validating release 'credhub'... Finished (00:00:03)
  Validating release 'bosh-system-metrics-server'... Finished (00:00:04)
  Validating release 'os-conf'... Finished (00:00:00)
  Validating release 'backup-and-restore-sdk'... Finished (00:00:21)
  Validating cpi release... Finished (00:00:00)
  Validating deployment manifest... Finished (00:00:00)
  Validating stemcell... Finished (00:00:00)
Finished validating (00:00:49)
Started installing CPI
  Compiling package 'golang/b1d1bd861b0fc14b92e2a88fed01de017037f242'... Finished (00:00:00)
  Compiling package 'bosh-google-cpi/cb55944988bbbbb6e425e95ab17e859490ba7088'... Finished (00:00:00)
  Installing packages... Finished (00:00:10)
  Rendering job templates... Finished (00:00:03)
  Installing job 'google_cpi'... Finished (00:00:00)
Finished installing CPI (00:00:14)
Starting registry... Finished (00:00:00)
Uploading stemcell 'bosh-google-kvm-ubuntu-trusty-go_agent/3541.12'... Skipped [Stemcell already uploaded] (00:00:00)
Started deploying
  Waiting for the agent on VM 'vm-6e00b45e-d584-410b-6372-535a1c589633'... Finished (00:00:00)
  Stopping jobs on instance 'unknown/0'... Finished (00:00:01)
  Unmounting disk 'disk-3563e12f-4edd-42cc-724c-9d9f1db17947'... Finished (00:00:08)
  Deleting VM 'vm-6e00b45e-d584-410b-6372-535a1c589633'... Finished (00:03:09)
  Creating VM for instance 'bosh/0' from stemcell 'stemcell-f02d864e-2ce3-4ddf-5907-39b465047cb8'... Finished (00:00:28)
  Waiting for the agent on VM 'vm-f1627bb3-cbcc-4d09-6592-fd0cd5f1370e' to be ready... Finished (00:00:25)
  Attaching disk 'disk-3563e12f-4edd-42cc-724c-9d9f1db17947' to VM 'vm-f1627bb3-cbcc-4d09-6592-fd0cd5f1370e'... Finished (00:00:21)
  Rendering job templates... Finished (00:00:56)
  Compiling package 'golang1.8.3/6b1bfba0bc0455c57678161490ce4fa4fd5f70f4'... Finished (00:00:21)
  Compiling package 'ruby-2.4-r3/8471dec5da9ecc321686b8990a5ad2cc84529254'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'backup-and-restore-release-golang/322af40566b61235b46a9c8db756aba7453818a5'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'golang/b1d1bd861b0fc14b92e2a88fed01de017037f242'... Finished (00:00:21)
  Compiling package 'database-backup-restorer-boost/c3aee061423c7de8e1bbe50db88f82379c54edf3'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'mysql/b7e73acc0bfe05f1c6cbfd97bf92d39b0d3155d5'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'libpq/3afb51e921e950abb31e5d039d2144591a41482d'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'openjdk_1.8.0/992d517cbe2e4977e4d948ed159134bbed7a8c20'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'lunaclient/b922e045db5246ec742f0c4d1496844942d6167a'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'system-metrics-plugin/66ad0949e300acfa8f148d18e45dc512adf037ec'... Finished (00:00:05)
  Compiling package 'health_monitor/a0b5a680f1cbfda4a17b2fedff93cc9b9d9d959c'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'database-backup-restorer-mysql-5.6/fd9ea31a8f101a53382f5415250072e61ab075e0'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'postgres-9.4/52b3a31d7b0282d342aa7a0d62d8b419358c6b6b'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'database-backup-restorer-mariadb/1838e76a6125c4e4b61d40a629edd5a94f388154'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'nginx/3518a530de39c41ec65abf1194c27aadae23b711'... Skipped [Package already compiled] (00:00:00)
  Compiling package 's3cli/b6e38c619dd5575e16ea9fcabc4b7c500effdd26'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'gonats/73ec55f11c24dd7c02288cdffa24446023678cc2'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'database-backup-restorer-mysql/1838e76a6125c4e4b61d40a629edd5a94f388154'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'database-backup-restorer/05be265c080ab8210fb828ea93eb04981a006828'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'database-backup-restorer-postgres-9.4/4f46c5bf4646634cdaf2d9bca922c82a561b8638'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'bosh-google-cpi/cb55944988bbbbb6e425e95ab17e859490ba7088'... Finished (00:00:13)
  Compiling package 'system-metrics-server/3c89f95bf6b1f0f147946bc47adca32b32f019b5'... Finished (00:00:09)
  Compiling package 'database-backup-restorer-mysql-5.7/d56501baf8c468226230eea0db3ec973e6c0319c'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'verify_multidigest/8fc5d654cebad7725c34bb08b3f60b912db7094a'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'uaa/a6c1696468fd14eec2d4c9e67b7afc2de51bd994'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'database-backup-restorer-postgres-9.6/acaa98101616ef46862d5c9f3bf8c5aa358da19b'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'bosh-gcscli/fce60f2d82653ea7e08c768f077c9c4a738d0c39'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'davcli/2672d0a96a775f5252fef6ac7bbab3928aa41599'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'director/0d042598ac5a6964d7de6b19b38a0d625386a8d6'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'credhub/316bd9b5f6aa5a04292b0ca88815fdbc1caae92b'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'uaa_utils/20557445bf996af17995a5f13bf5f87000600f2e'... Skipped [Package already compiled] (00:00:00)
  Compiling package 'database-backup-restorer-mysql-5.5/1c3e31db5fb4228b50565f0952a3387752fc4a23'... Skipped [Package already compiled] (00:00:00)
  Updating instance 'bosh/0'... Finished (00:01:39)
  Waiting for instance 'bosh/0' to be running... Finished (00:01:10)
  Running the post-start scripts 'bosh/0'... Finished (00:00:11)
Finished deploying (00:10:00)
Stopping registry... Finished (00:00:00)
Cleaning up rendered CPI jobs... Finished (00:00:00)
```

# Drawbacks

...

# Unresolved questions

...
