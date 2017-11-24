- State: discussing
- Start date: ?
- End date: ?
- Related proposals: [proposals/instance-logs.md](proposals/instance-logs.md)

# Summary

Director should track various blobs in one way and potentially expose it via consolidated API.

# Details

`blobs` table

[id, created_at, blobstore_id, sha1, type]

- blobstore_id is unique?

type:

- compiled-release (older than 1 hour)
- dns (older than 1 hour, always keep last 10) [foreign key]
[future]
- delete-log (per instance, keep last 10?)
- manual-log (per instance, keep last 10?)
- errand-log [fetch-log] (per instance, keep last 10?)
- tasks-log (when delete task, delete blob) [foreign key?]
- package (delete when it's not referenced) [foreign key?]
- compiled-package (delete when it's not referenced) [foreign key?]
- job (delete when it's not referenced) [foreign key?]

```
cleanup task - every 30 mins
	- InstnaceLogsCleanup
	  do distinct on instnace? + join blobs table
	    order by blob.created_at?
	      kill all but 10
	- ...
  - TasksCleanup
    remove tasks per type
      delete blobs
  - DnsCleanup
```

```
bosh download-blob blobstore-id [--sha1 ...]
  - can find out digest from the DB?
```

# Drawbacks

...

# Unresolved questions

- eventually move debug/... task output into the blobstore
- currently no way to delete all blobs from the blobstore
