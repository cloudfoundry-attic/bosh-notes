- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

...

# Motivation

...

# Details

### as a director api user, I expect to be able to hit `/link_instances' api endpoint to get back a list of instances

The behaviour should be similar to that of `link(...).instances.map { ... }`

### better authorization for links api consumer

Currently the requirement for creating and deleting a link requires admin permissions for the deployment. However this means it allows the consumer of the API to redeploy, start, stop, recreate, or in general mess with the deployment. What we want to do is have a more restrictive access to it. 

```
| Action         | Current Permission | Proposed permission                         |
-------------------------------------------------------------------------------------
| List Providers | read(deployment)   | read(deployment)                            |
| List Consumers | read(deployment)   | read(deployment)                            |
| List Links     | read(deployment)   | read(deployment)                            |
| Create Link    | admin              | read(deployment) + create_links(deployment) |
| Delete Link    | admin              | read(deployment) + delete_links(deployment) |
```

This allows other operators to consume from the deployment without exposing administrative privileges.

# Drawbacks

...

# Unresolved questions

...
