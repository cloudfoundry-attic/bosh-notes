- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

It should be possible to rotate CA certificates with the help of config server API without incurring any downtime.

# Motivation

Currently to rotate CA certificates one has to update deployment manifest to include multiple variable interpolations (eg `ca: ((cert1.ca))\n((cert2.ca))`). These manual changes are error prone and tedious. Proposed solution is to enhance config server API to simplify the workflow.

Ultimately the goal of such functionality is to make it easy to provide "certificate rotation" service that would work with config server API and Director to automatically rotate certificates (CAs and any other).

# Details

Config server API returns array of data items from `/v2/data?name=key`. Director can take advantage of this functionality and automatically concatenate `ca` portion of certificate values if multiple values are returned. By default `/v2/data?name=key` will return all history values; however, in this case Director only needs "active" values (as marked by the user inside a config server). To avoid receiving all values Director should include `active=true` query param so that config server only returns "active" values.

Following workflow would enable operator to rotate certificates and their CAs:

- operator deploys simple software
  - Director issues call to create-or-update `simple-ca` (type: certificate)
    - only v1 is active
  - Director issues call to create-or-update `simple-cert` (type: certificate) that uses `simple-ca` as its CA
    - only v1 is active
  - Director renders web-server job to use `simple-cert` as its server certificate (eg `((simple-cert.certificate))`)
  - Director renders web-client job to use `simple-cert`'s CA as its server certificate (eg `((simple-cert.ca))`)

- operator triggers to regenerate `simple-cert`
  - Director issues call to create-or-update `simple-ca`
    - only v1 is active
  - Director issues call to create-or-update `simple-cert`
    - only v2 is active (but using on v1 of simple-ca)
  - Director renders web-server job to use `simple-cert` as its server certificate (eg `((simple-cert.certificate))`)
  - Director renders web-client job to use `simple-cert`'s CA as its server certificate (eg `((simple-cert.ca))`)

- operator triggers to regenerate `simple-ca`
  - Director issues call to create-or-update `simple-ca`
    - v1 and v2 are active
  - Director issues call to create-or-update `simple-cert`
    - only v2 is active
  - Director renders web-server job to use `simple-cert` as its server certificate (eg `((simple-cert.certificate))`)
  - Director renders web-client job to use `simple-cert`'s CA as its server certificate (eg `((simple-cert.ca))`)
    - Director automatically concatenates v1 and v2 contents and returns result as a combined PEM string

- TBD: regenerate all certificates?
  - TBD: what about all intermediate certificates?

- operator triggers to regenerate `simple-ca`
  - Director issues call to create-or-update `simple-ca`
    - only v2 is active
  - Director issues call to create-or-update `simple-cert`
    - only v3 is active
  - Director renders web-server job to use `simple-cert` as its server certificate (eg `((simple-cert.certificate))`)
  - Director renders web-client job to use `simple-cert`'s CA as its server certificate (eg `((simple-cert.ca))`)
    - Director automatically concatenates v1 and v2 contents and returns result as a combined PEM string

# Drawbacks

...

# Unresolved questions

- How does this relate to password rotation?
- What happens when variable options change when kicking off a deploy?
- (see above TBD)
