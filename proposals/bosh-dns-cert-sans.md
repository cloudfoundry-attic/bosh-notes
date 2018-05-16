- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

BOSH Director should automatically configure certificates (variables) with correct names (CN and SANs).

# Motivation

Currently deployment authors (such as cf-deployment authors) have to configure various BOSH DNS aliases so that they can specify CN/SANs of certificates in variables section. This is necessary for regular TLS validation to work. Instead of having deployment authors manually manage DNS alias mapping we would like to have automated procedure determine necessary certificate configuration based on some manifest declarations. (This is quite similar to what we've done with IP addresses -- removed necessity to specify them manually in manifests.)

# Details

## Proposal

Typically Director shares information between different deployment pieces (eg jobs) via links. To follow this pattern, here is one way to solve for declaratively specifying which variables need which DNS information:

```
instance_groups:
- name: ...
  jobs:
  - name: bbs
    provides:
      bbs: {as: bbs2}

variables:
- name: bbs
  type: certificate
  consumes:
    wildcard_cn: {from: bbs2}
    wildcard_sans: {from: bbs2}
  options:
    alternative_names:
    - 127.0.0.1
```

```
instance_groups:
- name: ...
  jobs:
  - name: bbs
    default_provides:
      networking: {from: bbs_networking}

variables:
- name: bbs
  type: certificate
  consumes:
    wildcard_sans: {from: bbs_networking}
```

### Supported certificate link consumers

- wildcard_common_name
- wildcard_alternative_name
- common_name
- alternative_name

## Multiple alternative names


## `default_provides`

Instead of requiring all jobs that need certificates to expose a link just for the sake of certificate, Director should provide `default_provides.wildcard_alternative_name` of type <TBD> 

## Group DNS addresses

Most use cases that we have seen in the wild revolve around addressing group of instances instead of individual instances. We currently have a way to get a group DNS address via link(...).address ERB accessor.

## Short DNS addresses

Some software may not tolerate long DNS addresses. It also appears that x509 RFC only allows up to 64 chars in CN/SANs. MySQL is our current example of such software. OpenSSL generally does not like longer than 64 char CNs.

BOSH has a notion of short DNS addresses to avoid having to deal with long DNS names. They are generated automatically if deployment opts into features.use_short_dns_addresses. 

## CN vs SANs

Some software may require use of CN vs SANs.

## 

# Drawbacks

...

# Unresolved questions

...

## Certificate variables from cf-deployment

Common names from below:

```
common_name: silk-ca
common_name: silk-controller.service.cf.internal
common_name: silk-daemon
common_name: networkPolicyCA
common_name: policy-server.service.cf.internal
common_name: clientName
common_name: internalCA
common_name: blobstore.service.cf.internal
common_name: consulCA
common_name: consul_agent
common_name: server.dc1.cf.internal
common_name: auctioneer client
common_name: auctioneer.service.cf.internal
common_name: bbs client
common_name: bbs.service.cf.internal
common_name: rep client
common_name: cell.service.cf.internal
common_name: loggregatorCA
common_name: statsdinjector
common_name: metron
common_name: doppler
common_name: trafficcontroller
common_name: trafficcontroller
common_name: reverselogproxy
common_name: ss-adapter-rlp
common_name: ss-scheduler
common_name: ss-adapter
common_name: ss-scheduler
common_name: routerCA
common_name: routerSSL
common_name: uaaCA
common_name: uaa.service.cf.internal
common_name: uaa_login_saml
common_name: cloud-controller-ng.service.cf.internal
common_name: tps_watcher
common_name: cc_uploader
common_name: cc-uploader.service.cf.internal
common_name: locket.service.cf.internal
common_name: locket client
common_name: appRootCA
common_name: instanceIdentityCA
```

SANs from below:

```
alternative_names:
- 127.0.0.1

alternative_names:
- "*.auctioneer.service.cf.internal"
- auctioneer.service.cf.internal

alternative_names:
- "*.bbs.service.cf.internal"
- bbs.service.cf.internal

alternative_names:
- "*.cell.service.cf.internal"
- cell.service.cf.internal
- 127.0.0.1
- localhost

alternative_names:
- "((system_domain))"
- "*.((system_domain))"

alternative_names:
- uaa.service.cf.internal

alternative_names:
- "*.locket.service.cf.internal"
- locket.service.cf.internal
```

Full contents:

```
variables:
- name: silk_ca
  type: certificate
  options:
    is_ca: true
    common_name: silk-ca
- name: silk_controller
  type: certificate
  options:
    ca: silk_ca
    common_name: silk-controller.service.cf.internal
    extended_key_usage:
    - server_auth
- name: silk_daemon
  type: certificate
  options:
    ca: silk_ca
    common_name: silk-daemon
    extended_key_usage:
    - client_auth
- name: network_policy_ca
  type: certificate
  options:
    is_ca: true
    common_name: networkPolicyCA
- name: network_policy_server
  type: certificate
  options:
    ca: network_policy_ca
    common_name: policy-server.service.cf.internal
    extended_key_usage:
    - server_auth
- name: network_policy_client
  type: certificate
  options:
    ca: network_policy_ca
    common_name: clientName
    extended_key_usage:
    - client_auth
- name: service_cf_internal_ca
  type: certificate
  options:
    is_ca: true
    common_name: internalCA
- name: blobstore_tls
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: blobstore.service.cf.internal
- name: consul_agent_ca
  type: certificate
  options:
    is_ca: true
    common_name: consulCA
- name: consul_agent
  type: certificate
  options:
    ca: consul_agent_ca
    common_name: consul_agent
    extended_key_usage:
    - client_auth
    - server_auth
    alternative_names:
    - 127.0.0.1
- name: consul_server
  type: certificate
  options:
    ca: consul_agent_ca
    common_name: server.dc1.cf.internal
    extended_key_usage:
    - client_auth
    - server_auth
- name: diego_auctioneer_client
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: auctioneer client
    extended_key_usage:
    - client_auth
- name: diego_auctioneer_server
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: auctioneer.service.cf.internal
    extended_key_usage:
    - server_auth
    alternative_names:
    - "*.auctioneer.service.cf.internal"
    - auctioneer.service.cf.internal
- name: diego_bbs_client
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: bbs client
    extended_key_usage:
    - client_auth
- name: diego_bbs_server
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: bbs.service.cf.internal
    extended_key_usage:
    - server_auth
    - client_auth
    alternative_names:
    - "*.bbs.service.cf.internal"
    - bbs.service.cf.internal
- name: diego_rep_client
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: rep client
    extended_key_usage:
    - client_auth
- name: diego_rep_agent_v2
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: cell.service.cf.internal
    extended_key_usage:
    - client_auth
    - server_auth
    alternative_names:
    - "*.cell.service.cf.internal"
    - cell.service.cf.internal
    - 127.0.0.1
    - localhost
- name: loggregator_ca
  type: certificate
  options:
    is_ca: true
    common_name: loggregatorCA
- name: loggregator_tls_statsdinjector
  type: certificate
  options:
    ca: loggregator_ca
    common_name: statsdinjector
    extended_key_usage:
    - client_auth
- name: loggregator_tls_metron
  type: certificate
  options:
    ca: loggregator_ca
    common_name: metron
    extended_key_usage:
    - client_auth
    - server_auth
- name: loggregator_tls_doppler
  type: certificate
  options:
    ca: loggregator_ca
    common_name: doppler
    extended_key_usage:
    - client_auth
    - server_auth
- name: loggregator_tls_tc
  type: certificate
  options:
    ca: loggregator_ca
    common_name: trafficcontroller
    extended_key_usage:
    - client_auth
    - server_auth
- name: loggregator_tls_cc_tc
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: trafficcontroller
    extended_key_usage:
    - client_auth
- name: loggregator_tls_rlp
  type: certificate
  options:
    ca: loggregator_ca
    common_name: reverselogproxy
    extended_key_usage:
    - client_auth
    - server_auth
- name: adapter_rlp_tls
  type: certificate
  options:
    ca: loggregator_ca
    common_name: ss-adapter-rlp
    extended_key_usage:
    - client_auth
    - server_auth
- name: scheduler_api_tls
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: ss-scheduler
    extended_key_usage:
    - client_auth
    - server_auth
- name: adapter_tls
  type: certificate
  options:
    ca: loggregator_ca
    common_name: ss-adapter
    extended_key_usage:
    - server_auth
    - client_auth
- name: scheduler_client_tls
  type: certificate
  options:
    ca: loggregator_ca
    common_name: ss-scheduler
    extended_key_usage:
    - client_auth
- name: router_ca
  type: certificate
  options:
    is_ca: true
    common_name: routerCA
- name: router_ssl
  type: certificate
  options:
    ca: router_ca
    common_name: routerSSL
    alternative_names:
    - "((system_domain))"
    - "*.((system_domain))"
- name: uaa_ca
  type: certificate
  options:
    is_ca: true
    common_name: uaaCA
- name: uaa_ssl
  type: certificate
  options:
    ca: uaa_ca
    common_name: uaa.service.cf.internal
    alternative_names:
    - uaa.service.cf.internal
- name: uaa_login_saml
  type: certificate
  options:
    ca: uaa_ca
    common_name: uaa_login_saml
- name: cc_tls
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: cloud-controller-ng.service.cf.internal
    extended_key_usage:
    - client_auth
    - server_auth
- name: cc_bridge_tps
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: tps_watcher
    extended_key_usage:
    - client_auth
- name: cc_bridge_cc_uploader
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: cc_uploader
    extended_key_usage:
    - client_auth
- name: cc_bridge_cc_uploader_server
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: cc-uploader.service.cf.internal
    extended_key_usage:
    - server_auth
- name: diego_locket_server
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: locket.service.cf.internal
    extended_key_usage:
    - server_auth
    alternative_names:
    - "*.locket.service.cf.internal"
    - locket.service.cf.internal
- name: diego_locket_client
  type: certificate
  options:
    ca: service_cf_internal_ca
    common_name: locket client
    extended_key_usage:
    - client_auth
- name: locket_database_password
  type: password
- name: application_ca
  type: certificate
  options:
    common_name: appRootCA
    is_ca: true
- name: diego_instance_identity_ca
  type: certificate
  options:
    ca: application_ca
    common_name: instanceIdentityCA
    is_ca: true
```
