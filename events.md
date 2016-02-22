# Events

```
$ bosh events

ID        Time                          User   Action        Object type  Object ID   Task  Dep   Inst      Context  
142<-141  Mon Feb 22 19:23:31 UTC 2016  admin  delete        deployment   dep1        16    -     -         -
141       Mon Feb 22 19:23:31 UTC 2016  admin  delete        deployment   dep1        16    -     -         -
140<-137  Mon Feb 22 19:23:31 UTC 2016  admin  update        deployment   zook        16    -     -         -
130<-129  Mon Feb 22 19:23:31 UTC 2016  hm     create        vm           i-29t594    16    zook  zoo/3184  -
129       Mon Feb 22 19:23:31 UTC 2016  hm     create        vm           -           16    zook  zoo/3184  -
134<-134  Mon Feb 22 19:23:31 UTC 2016  admin  delete        disk         vol-134855  16    zook  zoo/3184  error: "Could not find 'vol-134855'"
134       Mon Feb 22 19:23:31 UTC 2016  admin  delete        disk         vol-134855  16    zook  zoo/3184  -
132<-132  Mon Feb 22 19:23:31 UTC 2016  hm     delete        vm           i-329454    16    zook  zoo/3184  -
132       Mon Feb 22 19:23:31 UTC 2016  hm     delete        vm           i-329454    16    zook  zoo/3184  -
139<-138  Mon Feb 22 19:23:31 UTC 2016  admin  update        instance     zoo/3184    16    zook  -         -
138       Mon Feb 22 19:23:31 UTC 2016  admin  update        instance     zoo/3184    16    zook  -         changes: [dns,network]
137       Mon Feb 22 19:23:31 UTC 2016  admin  update        deployment   zook        16    -     -         -
137       Mon Feb 22 19:23:31 UTC 2016  admin  create        task         16          -     -     –         class: UpdateDeployment
136<-120  Mon Feb 22 19:23:31 UTC 2016  admin  create        task         15          -     -     -         -
136<-123  Mon Feb 22 19:23:31 UTC 2016  admin  create        deployment   zook        15    -     -         -
136       Mon Feb 22 19:23:31 UTC 2016  admin  clean-up-ssh  instance     zoo/3184    15    zook  zoo/3184  user: bosh_blah
135       Mon Feb 22 19:23:31 UTC 2016  admin  set-up-ssh    instance     zoo/3184    15    zook  zoo/3184  user: bosh_blah
134       Mon Feb 22 19:23:31 UTC 2016  admin  orphan        disk         vol-134855  15    zook  zoo/3184  -
134       Mon Feb 22 19:23:31 UTC 2016  admin  attach        disk         vol-134855  15    zook  zoo/3184  vm: i-329454
133       Mon Feb 22 19:23:31 UTC 2016  admin  attach        disk         vol-348544  15    zook  zoo/3184  vm: i-459566
132<-132  Mon Feb 22 19:23:31 UTC 2016  admin  delete        vm           i-329454    15    zook  zoo/3184  -
132       Mon Feb 22 19:23:31 UTC 2016  admin  delete        vm           i-329454    15    zook  zoo/3184  -
131<-131  Mon Feb 22 19:23:31 UTC 2016  admin  create        disk         vol-348544  15    zook  zoo/3184  -
131       Mon Feb 22 19:23:31 UTC 2016  admin  create        disk         -           15    zook  zoo/3184  -
130<-129  Mon Feb 22 19:23:31 UTC 2016  admin  create        vm           i-459566    15    zook  zoo/3184  -
129       Mon Feb 22 19:23:31 UTC 2016  admin  create        vm           -           15    zook  zoo/3184  -
128<-128  Mon Feb 22 19:23:31 UTC 2016  admin  create        disk         vol-134855  15    zook  zoo/1950  -
128       Mon Feb 22 19:23:31 UTC 2016  admin  create        disk         -           15    zook  zoo/1950  -
127<-126  Mon Feb 22 19:23:31 UTC 2016  admin  create        vm           i-12r985    15    zook  zoo/1950  -
126       Mon Feb 22 19:23:31 UTC 2016  admin  create        vm           -           15    zook  zoo/1950  -
125       Mon Feb 22 19:23:31 UTC 2016  admin  create        instance     zoo/3184    15    zook  -         -
124       Mon Feb 22 19:23:31 UTC 2016  admin  create        instance     zoo/1950    15    zook  -         -
123       Mon Feb 22 19:23:31 UTC 2016  admin  create        deployment   zook        15    -     -         -
120       Mon Feb 22 19:23:31 UTC 2016  admin  create        task         15          -     -     -         class: UpdateDeployment
120<-118  Mon Feb 22 19:23:31 UTC 2016  admin  create        task         14          -     -     -         -
122<-121  Mon Feb 22 19:23:31 UTC 2016  admin  create        release      zk/0+dev.1  14    -     -         -
121<-120  Mon Feb 22 19:23:31 UTC 2016  admin  create        blob         c39r5t6y93  14    -     -         -
121<-120  Mon Feb 22 19:23:31 UTC 2016  admin  create        blob         ac38fd8v34  14    -     -         -
120       Mon Feb 22 19:23:31 UTC 2016  admin  create        blob         -           14    -     -         package: zook/23r95y666 sha1: wd34r35062
120       Mon Feb 22 19:23:31 UTC 2016  admin  create        blob         -           14    -     -         package: java/893454g60 sha1: f29t596435
121       Mon Feb 22 19:23:31 UTC 2016  admin  create        release      zk/0+dev.1  14    -     -         -
120       Mon Feb 22 19:23:31 UTC 2016  admin  create        task         14          -     -     -         class: UpdateRelease
120<-118  Mon Feb 22 19:23:31 UTC 2016  admin  create        task         13          -     -     -         -
120<-117  Mon Feb 22 19:23:31 UTC 2016  admin  create        task         12          -     -     -         -
120<-119  Mon Feb 22 19:23:31 UTC 2016  admin  create        stemcell     ami-3435    13    -     -         name: bosh-warden-stemcell/3147.1
120<-119  Mon Feb 22 19:23:31 UTC 2016  admin  create        stemcell     ami-2a89    12    -     -         name: bosh-warden-stemcell/3147.1
119       Mon Feb 22 19:23:31 UTC 2016  admin  create        stemcell     -           13    -     -         name: bosh-warden-stemcell/3147
119       Mon Feb 22 19:23:31 UTC 2016  admin  create        stemcell     -           12    -     -         name: bosh-warden-stemcell/3147
118       Mon Feb 22 19:23:31 UTC 2016  admin  create        task         13          -     -     -         class: UpdateStemcell
117       Mon Feb 22 19:23:31 UTC 2016  admin  create        task         12          -     -     -         class: UpdateStemcell
```

Note that IDs will not be numeric. Parent IDs in the above example are not correctly referenced.

```
$ bosh events --deployment=zook
$ bosh events --instance=zoo/1950
$ bosh events --task=15
$ bosh events --before "Mon Feb 22 19:30:31 UTC 2016" --after "Mon Feb 22 19:23:31 UTC 2016"
$ bosh events --before-id 117
$ bosh event 117
```

## Fields

**common fields**
- id (string)
- parent_id (string|null)
- user (string)
- timestamp (time)
- action (string)
- object_type (string)
- object_id (string)
- error (string|null)
- task (string|null)
- deployment (string|null)
- instance (string|null)
- context (json)

task
- object_id: "task id"
- ending actions: [run]
- single actions: [cancel]
- context: [class]

blob
- object_id: "blob id"
- ending actions: [create, delete]
- context: [package, job, log, sha1]

stemcell
- object_id: "cid"
- actions: [create, delete]

release
- object_id: "cid"
- actions: [create, delete]

cloud-config
- object_id: "name"
- single actions: [update]

runtime-config
- object_id: "name"
- single actions: [update]

deployment
- object_id: "name"
- ending actions: [create, update, delete]
- single actions: [rename, back_up]
- context: [old_releases, new_releases, old_stemcells, new_stemcells]

instance
- object_id: "name/id"
- ending actions: [update, start, stop, recreate, delete]
- single actions: [set-up-ssh, clean-up-ssh]
- context: [changes, az]

errand
- object_id: "name"
- ending actions: [run]

vm
- object_id: "cid"
- ending actions: [create, delete]
- single actions: [lose]

disk
- object_id: "cid"
- ending actions: [create, delete, attach, detach]
- single actions: [orphan, unorphan]

process
- object_id: "name"
- single actions: [lose]

## API

**common filters for listing**
- task=X
- deployment=X
- instance=X

/events
- array of event hashes
- 200 most recent events first

/events?after_time=timestamp
- 200 events from the beginning of timestamp
- includes events with timestamp
- sorted by timestamp in asc

/events?before_time=timestamp
- 200 events before the last of timestamp
- includes events with timestamp
- sorted by timestamp in asc

/events?after_id=id
- 200 events from that ID
- excludes given ID
- sorted by timestamp in asc

/events?before_id=id
- 200 events upto that ID
- excludes given ID
- sorted by timestamp in asc

/events/id
- single event

Events are truncated after 10_000 entries, oldest first.

## Stories v1

- record deployment update
- record cloud-config update
- record runtime-config update
- periodically truncate to 10_000 events, deleting oldest first
- can view 200 events before id via cli
- can filter events based on deployment, instance, and task via cli
- record instance creation/deletion
- record vm creation/deletion
- record disk creation/deletion

## Stories v2

- record disk orpahn/unorphan
- record disk attach/detach
- record blobs
- record stemcell
- record release
- record task

# TBD

- how to record lost processes and vms (action=lose)?
