- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

Operator should be able to execute an errand with specific set of arguments via CLI.

# Motivation

Example of commands that operator has to run for logsearch [1](https://github.com/cloudfoundry-community/logsearch-boshrelease/blob/ee8467b4943968e58a07e1c05d9c20529ef5540f/docs/troubleshooting.md#deleting-translog):

```
# If the transaction log of a shard gets corrupted after a crash it needs to be removed manually on all nodes.
$ rm -rf /var/vcap/store/elasticsearch/<CLUSTER_NAME>/nodes/<NODE_NUM>/indices/<INDEX_NAME>/<SHARD_NUM>/translog/
```

# Details

...

# Drawbacks

...

# Unresolved questions

- erb templating, etc.
