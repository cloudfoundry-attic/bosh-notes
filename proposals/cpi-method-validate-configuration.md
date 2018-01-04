- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

BOSH should be able ask CPIs if their configuration (IaaS creds, connectivity, etc.) is valid. 

# Motivation

Reasons:

- better and earlier error messaging for CPI configuration problem
- monitor if status of validation fails

Use cases:

- find out if credentials have expired
- find out if CPI has proper outbound connectivity to IaaS API endpoints
- find out if CPI has proper access to certain resources (ie can find region?)
- find out if IaaS API is available

# Details

## Proposed solution

- add new CPI method `validate_configuration`
- have Director call CPI method during `bosh cck`
  - this would assume that operator has empty deployment

## IaaS specifics

Possible properties to check during validate configuration CPI call:

- AWS
  - connect to ??? endpoint (checks creds and internet connectivity)
  - properties to validate
    - default_iam_instance_profile: (presence?)
    - default_key_name: (presence?)
    - default_security_groups: (presence?)
    - region:
    - ec2_endpoint:
    - elb_endpoint:
    - kms_key_arn: (presence?)

- Azure
  - connect to ??? endpoint (checks creds and internet connectivity)
  - properties to validate
    - environment:
    - location:
    - subscription_id: (presence?)
    - resource_group_name: (presence?)
    - storage_account_name: (presence?)
    - tenant_id: (presence?)
    - client_id:
    - client_secret:
    - certificate:
    - default_security_group: (presence?)
    - azure_stack.domain:
    - azure_stack.authentication:
    - azure_stack.resource:
    - azure_stack.endpoint_prefix:
    - azure_stack.ca_cert:

- vSphere
  - connect to ??? endpoint (checks creds and internet connectivity)
  - properties to validate
    - address:
    - user:
    - password:
    - datacenters.clusters.resource_pool (presence?)
    - nsx.address:
    - nsx.user:
    - nsx.password:
    - nsx.ca_cert:
    - nsxt.host:
    - nsxt.username:
    - nsxt.password:
    - nsxt.ca_cert:

- OpenStack
  - connect to ??? endpoint (checks creds and internet connectivity)
  - properties to validate
    - auth_url:
    - username:
    - api_key:
    - tenant: (presence?)
    - project: (presence?)
    - domain: (presence?)
    - region: (presence?)
    - endpoint_type:
    - default_key_name: (presence?)
    - default_security_groups: (presence?)
    - default_volume_type: (presence?)

- GCP
  - connect to ??? endpoint (checks creds and internet connectivity)
  - properties to validate
    - project: (presence?)
    - json_key:

- Warden & Docker
  - connect to ??? endpoint (internet connectivity)
  
## Possible integrations

This check could be automated to run by the monitoring software on a timer and be alerted on.

# Drawbacks

- adds time to the deploy

# Unresolved questions

- should CPIs check for permissions?
- create-env integration?
