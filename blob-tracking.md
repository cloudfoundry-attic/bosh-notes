# Blob Tracking

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

## Fetching blob

```
bosh download-blob blobstore-id [--sha1 ...]
  - can find out digest from the DB?
```

## Instance logs

```
bosh [OPTIONS] logs [--prev] [logs-OPTIONS] [INSTANCE-GROUP[/INSTANCE-ID]]
bosh logs --prev -d foo
bosh logs --prev -d foo mysql
bosh logs --prev -d foo mysql/w98ry3467495y7
```

- different command?

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

## TBD

- eventually move debug/... task output into the blobstore
- currently no way to delete all blobs from the blobstore
