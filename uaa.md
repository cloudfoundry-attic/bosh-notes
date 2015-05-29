# Director UAA Integration

Director authentication and authorization can be configured in two different ways: with and without [UAA](https://github.com/cloudfoundry/uaa). Non-UAA mode is used to provide an extremely simple, built-in way of authenticating. UAA mode is used for more rich, interactive configuration i.e. local dynamic users, LDAP integration, password, lockout policies, etc.

## Non-UAA mode

Conditions:
- simple setup without external dependencies (e.g. LDAP server)
- no special access rules (i.e. everyone gets full admin rights)
- static list of users that cannot be changed while the Director is running

When deploying the Director (with bosh-init for example), it is configured with predefined set of users via the manifest. For example:

```
properties:
  director:
    users:
    - {name: admin, hashed_password: "$6$4gDD3aV0rdql...kMmbpwBC6jsHt0"}
    - {name: other, hashed_password: "$6$4gDDHJF0rdql...kMmbFDFFK6jsH3"}
```

There will be no way to add/delete users while the Director is running until the manifest is changed and Director is redeployed. `bosh create/delete user` CLI commands will be removed.

## UAA mode

Conditions:
- complex setup (e.g. supports LDAP, SAML, local users)
- granular access rules (e.g. full admin vs readonly vs specific deployments)

When deploying the Director (with bosh-init for example), it is configured with a UAA server URL (collocated on the same VM or is deployed somewhere else) so that the Director and the CLI can talk to UAA and request access tokens.

bosh-init repo contains [more details on how to configure UAA](https://github.com/cloudfoundry/bosh-init/blob/master/docs/uaa.md).

### Authorization

* User can modify everything (i.e. full admin)
  - covered by `bosh.director.admin`
  - covered by `bosh.director.<DIRECTOR-UUID>.admin`

* User can view everything (i.e. full read-only access)
  - covered by `bosh.director.<DIRECTOR-UUID>.read`

* Users can modify certain deployments that already exist and new ones that they create (i.e. tagged deployments)
  - covered by `bosh.director.<DIRECTOR-UUID>.deployments-tag.<TAG>.admin`
  - Example: service broker is given a client id/secret and a tag. service broker will create deployments with tag X and would like to view and update it.

## Stories

See [BOSH & UAA Integration Tracker](https://www.pivotaltracker.com/n/projects/1285490).

## TBD

- ok to use director-uuid in the scope name?
- do we need bosh.director.admin that provides global admin access?
