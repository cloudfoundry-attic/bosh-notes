# CLI: `bosh instances`

## Instances

`instances` commands operates on the current deployment. It should show a row even for instances that do not have an associated VM.

```
$ bosh instances --details

+-----------+--------------------+----+---------------+-----+------------+------------+--------------------------------------+--------------+
| Instance  | State              | AZ | Resource Pool | IPs | VM CID     | Disk CID   | Agent ID                             | Resurrection |
+-----------+--------------------+----+---------------+-----+------------+------------+--------------------------------------+--------------+
| api/vihr7 | unresponsive agent | z1 |               |     | i-dc20e10e | vol-dc2bla | 5e1f2353-1f2b-421e-bb3e-aa82b3fd8089 | active       |
+-----------+--------------------+----+---------------+-----+------------+------------+--------------------------------------+--------------+
```

Presence of `--failing` flag results in only showing instances that do not have `running` state (e.g. unresponsive agent, etc.).

## Processes

`--ps` includes detailed process information for each one of the instances. State for the instance is an aggregate. State of each process will be pulled directly from monit.

```
$ bosh instances --ps

+------------------------------------+---------+----+---------------+-------------+
| Instance                           | State   | AZ | Resource Pool | IPs         |
+------------------------------------+---------+----+---------------+-------------+
| api/vihr7                          | running | z1 | api           | 10.10.80.16 |
|   cloud_controller_ng              | running |    |               |             |
|   cloud_controller_worker_local_1  | running |    |               |             |
|   cloud_controller_worker_local_2  | running |    |               |             |
+------------------------------------+---------+----+---------------+-------------+
| api/scn23                          | running | z2 | api           | 10.10.80.16 |
|   cloud_controller_ng              | running |    |               |             |
|   cloud_controller_worker_local_1  | running |    |               |             |
|   cloud_controller_worker_local_2  | running |    |               |             |
+------------------------------------+---------+----+---------------+-------------+
```

Presence of both `--ps` and `--failing` flags results in only showing instances and processes that do not have `running` state.

```
$ bosh instances --ps --failing

+------------------------------------+------------------+---------------+-------------+
| Instance                           | State            | Resource Pool | IPs         |
+------------------------------------+------------------+---------------+-------------+
| api/vihr7                          | failing          | router_z2     | 10.10.80.16 |
|   cloud_controller_worker_local_2  | Execution failed |               |             |
+------------------------------------+------------------+---------------+-------------+
```

### Processes + Vitals

Presence of both `--ps` and `--vitals` flags results in showing instance and process vitals for each one of the instances.

```
$ bosh instances --ps --vitals

+------------------------------------+---------+---------------+--------------+-----------------------+------+------+-------+--------------+------------+------------+------------+------------+
| Instance                           | State   | Resource Pool | IPs          |         Load          | CPU  | CPU  | CPU   | Memory Usage | Swap Usage | System     | Ephemeral  | Persistent |
|                                    |         |               |              | (avg01, avg05, avg15) | User | Sys  | Wait  |              |            | Disk Usage | Disk Usage | Disk Usage |
+------------------------------------+---------+---------------+--------------+-----------------------+------+------+-------+--------------+------------+------------+------------+------------+
| uaa_z2/0                           | running | medium_z2     | 10.10.81.18  | 0.00, 0.01, 0.05      | 0.2% | 0.1% | 0.1%  | 17% (653.6M) | 0% (0B)    | 47%        | 0%         | 47%        |
|
| cloud_controller_ng
|   status                             running
|   monitoring status                  monitored
|   pid                                30269
|   parent pid                         1
|   uptime                             1d 16h 16m
|   children                           10
|   memory kilobytes                   818996
|   memory kilobytes total             835824
|   memory percent                     10.6%
|   memory percent total               10.9%
|   cpu percent                        0.4%
|   cpu percent total                  0.4%
|   port response time                 0.034s to 10.10.80.255:9022/v2/info [HTTP via TCP]
|   data collected                     Fri Jul 24 23:30:12 2015
|
| cloud_controller_worker_local_1
|   status                             running
|   monitoring status                  monitored
|   pid                                30383
|   parent pid                         1
|   uptime                             1d 16h 16m
|   children                           10
|   memory kilobytes                   198312
|   memory kilobytes total             215216
|   memory percent                     2.5%
|   memory percent total               2.8%
|   cpu percent                        0.0%
|   cpu percent total                  0.0%
|   data collected                     Fri Jul 24 23:30:12 2015
|
| cloud_controller_worker_local_2
|   status                             running
|   monitoring status                  monitored
|   pid                                30425
|   parent pid                         1
|   uptime                             1d 16h 16m
|   children                           10
|   memory kilobytes                   190168
|   memory kilobytes total             207392
|   memory percent                     2.4%
|   memory percent total               2.7%
|   cpu percent                        0.0%
|   cpu percent total                  0.0%
|   data collected                     Fri Jul 24 23:30:12 2015
|
| nginx_cc
|   status                             running
|   monitoring status                  monitored
|   pid                                30340
|   parent pid                         1
|   uptime                             1d 16h 16m
|   children                           1
|   memory kilobytes                   604
|   memory kilobytes total             6772
|   memory percent                     0.0%
|   memory percent total               0.0%
|   cpu percent                        0.0%
|   cpu percent total                  0.0%
|   data collected                     Fri Jul 24 23:30:12 2015
|
| nginx_newrelic_plugin
|   status                             running
|   monitoring status                  monitored
|   pid                                30465
|   parent pid                         1
|   uptime                             1d 16h 16m
|   children                           10
|   memory kilobytes                   30844
|   memory kilobytes total             46004
|   memory percent                     0.4%
|   memory percent total               0.6%
|   cpu percent                        0.0%
|   cpu percent total                  0.0%
|   data collected                     Fri Jul 24 23:30:12 2015
|
| cloud_controller_migration
|   status                             running
|   monitoring status                  monitored
|   pid                                30506
|   parent pid                         1
|   uptime                             1d 16h 16m
|   children                           10
|   memory kilobytes                   700
|   memory kilobytes total             16788
```

## VMs

`bosh vms` command stays the same.

## Disks

```
$ bosh disks

+------------+------------+------+----------+--------+
| Job/index  | Disk CID   | Size | Attached | Active |
+------------+------------+------+----------+--------+
| api/kv84f  | vol-dc2bla | 10gb | yes      | yes    |
|            | vol-kc8445 | 10gb | yes      | no     |
| api/kv84f  | vol-dc2bla | 10gb | yes      | yes    |
| api/er6hg  | vol-dc2bla | 10gb | yes      | yes    |
| api/dhbtf  | vol-dc2bla | 10gb | yes      | yes    |
| api/45gg4  | vol-dc2bla | 10gb | yes      | yes    |
| api/ab53d  | vol-dc2bla | 10gb | yes      | yes    |
| api/34vgi  | vol-dc2bla | 10gb | yes      | yes    |
| api/qt45k  | vol-dc2bla | 10gb | yes      | yes    |
+------------+------------+------+----------+--------+
```
