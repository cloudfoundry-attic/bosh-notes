- State: discussing
- Start date: ?
- End date: ?
- Docs: ?
- Related proposals: [proposals/blob-tracking.md](proposals/blob-tracking.md)

# Summary

Director should record instance logs before terminating instances and provide a way for users to download these logs at a later time.

# Motivation

...

# Details

Proposed additions to `bosh logs` command:

```
bosh [OPTIONS] logs [--prev] [logs-OPTIONS] [INSTANCE-GROUP[/INSTANCE-ID]]
bosh logs --prev -d foo
bosh logs --prev -d foo mysql
bosh logs --prev -d foo mysql/w98ry3467495y7
```

<example output>

`--prev` flag indicates to show historic record of logs.

Log storage events are recorded:

```
bosh events --instance ... --object-type logs
starting event:
  action=fetch
  object-type=logs
  object-name=empty
  instance=instance-id
ending event:
  action=fetch
  object-type=logs
  object-name=empty
  instance=instance-id
  context={blobstore_id: ... sha1: ...}
  error=?
```

`instance_logs` table

[id, blob_id, instance, group, deployment]
32       mysql/... mysql  foo
<when id is empty - blob failure>

- blob_id - foreign key to blobs table

# Drawbacks

- arguably different system should be responsible for log storage and retrieval

# Unresolved questions

- different command from `bosh logs`?
