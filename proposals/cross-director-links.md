- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary
Bringing up foundations using BOSH is getting easier, which is allowing you to create more and more foundations. But allowing these foundations to talk to each other if they are not under the same BOSH director is really difficult.

With help of Links API operators can create `external links` without the need for a separate consumer deployment on the same director. It will allow your deployments to talk to each other even if they are not under the same director.

In ideal world this process can be seamless and director-2 can talk to director-1 when deploying software and create external link and extract details and share it with deployment-2 on director-2.


# Motivation
- Allowing cross-foundation to talk to each other which are managemened by different directors.
- It will allow cross-foundation AZ architecture and can also support cross-dc architecture.
- Allow service brokers to manage services external to BOSH to talk to application internal to BOSH (more decoupling)
- Better visualization of provider changes to calculate the impact footprint.
- Better usage calculation and removal of unused providers

# Details
![alt text](https://github.com/cloudfoundry/bosh-notes/blob/master/proposals/cross-director-links.png)

As per the diagram in ideal world:
- BOSH-1 will have a deployment-1
- BOSH-2 will have `bosh-admin/client` credentials to call links endpoint, we can call it `bosh-link-profiles`

  ```
  link_profile:
    name: bosh-1
    url: https://10.0.10.5:85555 #something for auth
    client: admin
    password: admin
  ```
  
- deployment-2 on BOSH-2 will use this link profile to initiate consumption of external links

  ```
  consumes:
    primary_db:
      from: db
      deployment: deployment-1
      link_profile_name: bosh-1
  ```
  
 - BOSH-2 will use this link profile name 
   - create external links
   - extract contents of the links
   - use it in the consumer of deployment-2
 
 - If all network configuration are correct deployment-2 will use the properties from the link and can talk to deployment-1

# Drawbacks
- Auth part is still not clear right now.
- How the HA behaviour will come into picture
- 


# Unresolved questions
- How BOSH DNS will work in case of different director
  - may be resolved using some configuration.

...
