- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

As an operator, I expect Director to parallelize and be as speedy as possible when performing deploys (fresh or existing update).

# Motivation

...

# Details

Example #1:

- set_vm_metadata in parallel across multiple instances (done?)
- create persistent disks in parallel across multiple instances
- attach persistent disks in parallel across multiple instances
- download job/packages in parallel across multiple instances
- remove 5s monit reload time spent

# Drawbacks

...

# Unresolved questions

...

---

# Examples

1. Example Kube 4 node (master + worker) on GCP fresh deploy:

```
ID                            Started at                    Ended at  Duration                                                              Group                                                                                                                     Content
Wed Apr 11 17:39:53 UTC 2018  Wed Apr 11 17:39:57 UTC 2018  4s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [cpi req] create_disk -> [cpi resp] disk-d427bfa9-8000-47fc-6dee-5b5b70cc6696 3
Wed Apr 11 17:33:20 UTC 2018  Wed Apr 11 17:33:20 UTC 2018  0s        task:4880                                                             [agent req]  1
Wed Apr 11 17:33:32 UTC 2018  Wed Apr 11 17:33:44 UTC 2018  12s       create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [cpi req] create_vm -> [cpi resp] vm-933611f1-2097-4dff-567a-430c8a3bf450 2
~                             Wed Apr 11 17:33:51 UTC 2018  19s       create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [cpi req] create_vm -> [cpi resp] vm-2ffe814b-f1b4-4d96-62bd-50038d12911f 2
~                             Wed Apr 11 17:33:56 UTC 2018  24s       create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [cpi req] create_vm -> [cpi resp] vm-ee2c2932-f754-46f8-50ff-eae21e23bc43 2
Wed Apr 11 17:33:33 UTC 2018  Wed Apr 11 17:33:52 UTC 2018  19s       create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [cpi req] create_vm -> [cpi resp] vm-dcaad1de-94fb-4a47-6317-777b72ce7263 2
~                             Wed Apr 11 17:33:56 UTC 2018  23s       create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [cpi req] create_vm -> [cpi resp] vm-0eb7f462-67fb-47af-741f-8306e13e1fcc 2
Wed Apr 11 17:33:44 UTC 2018  Wed Apr 11 17:33:58 UTC 2018  14s       create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [cpi req] set_vm_metadata vm-933611f1-2097-4dff-567a-430c8a3bf450 -> [cpi resp]  2
Wed Apr 11 17:33:51 UTC 2018  Wed Apr 11 17:34:01 UTC 2018  10s       create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [cpi req] set_vm_metadata vm-2ffe814b-f1b4-4d96-62bd-50038d12911f -> [cpi resp]  2
Wed Apr 11 17:33:52 UTC 2018  Wed Apr 11 17:34:01 UTC 2018  9s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [cpi req] set_vm_metadata vm-dcaad1de-94fb-4a47-6317-777b72ce7263 -> [cpi resp]  2
Wed Apr 11 17:33:56 UTC 2018  Wed Apr 11 17:34:01 UTC 2018  5s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [cpi req] set_vm_metadata vm-ee2c2932-f754-46f8-50ff-eae21e23bc43 -> [cpi resp]  2
~                             Wed Apr 11 17:34:06 UTC 2018  10s       create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [cpi req] set_vm_metadata vm-0eb7f462-67fb-47af-741f-8306e13e1fcc -> [cpi resp]  2
Wed Apr 11 17:33:58 UTC 2018  Wed Apr 11 17:33:58 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
Wed Apr 11 17:33:59 UTC 2018  Wed Apr 11 17:33:59 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
Wed Apr 11 17:34:00 UTC 2018  Wed Apr 11 17:34:00 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
Wed Apr 11 17:34:01 UTC 2018  Wed Apr 11 17:34:01 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:01 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:01 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:01 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:02 UTC 2018  Wed Apr 11 17:34:02 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:02 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:02 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:02 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:03 UTC 2018  Wed Apr 11 17:34:03 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:03 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:03 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:03 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:04 UTC 2018  Wed Apr 11 17:34:04 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:04 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:04 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:04 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:05 UTC 2018  Wed Apr 11 17:34:05 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:05 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:05 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:05 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:06 UTC 2018  Wed Apr 11 17:34:06 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:06 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:06 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:06 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:06 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:07 UTC 2018  Wed Apr 11 17:34:07 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:07 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:07 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:07 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:07 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:08 UTC 2018  Wed Apr 11 17:34:08 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:08 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:08 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:08 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:08 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:09 UTC 2018  Wed Apr 11 17:34:09 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:09 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:09 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:09 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:09 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:10 UTC 2018  Wed Apr 11 17:34:10 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:10 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:10 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:10 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:10 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:11 UTC 2018  Wed Apr 11 17:34:11 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:11 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:11 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:11 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:11 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:12 UTC 2018  Wed Apr 11 17:34:12 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:12 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:12 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:12 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:12 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:13 UTC 2018  Wed Apr 11 17:34:13 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:13 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:13 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:13 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:13 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:14 UTC 2018  Wed Apr 11 17:34:14 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:14 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:14 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:14 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:14 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
Wed Apr 11 17:34:15 UTC 2018  Wed Apr 11 17:34:15 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:15 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:15 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:15 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
Wed Apr 11 17:34:16 UTC 2018  Wed Apr 11 17:34:16 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:16 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:16 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:16 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:16 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
Wed Apr 11 17:34:17 UTC 2018  Wed Apr 11 17:34:17 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:17 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:17 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:17 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:17 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
Wed Apr 11 17:34:18 UTC 2018  Wed Apr 11 17:34:18 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:18 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:18 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:18 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:18 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
Wed Apr 11 17:34:19 UTC 2018  Wed Apr 11 17:34:19 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:19 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:19 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:19 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:19 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
Wed Apr 11 17:34:20 UTC 2018  Wed Apr 11 17:34:20 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:20 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:20 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:20 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:20 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
Wed Apr 11 17:34:21 UTC 2018  Wed Apr 11 17:34:21 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:21 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:21 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:21 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:21 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
Wed Apr 11 17:34:22 UTC 2018  Wed Apr 11 17:34:22 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] ping -> [agent resp] 2
~                             Wed Apr 11 17:34:22 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping 1
~                             Wed Apr 11 17:34:25 UTC 2018  3s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] update_settings -> [agent resp] 10
~                             Wed Apr 11 17:34:22 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] ping -> [agent resp] 2
~                             Wed Apr 11 17:34:25 UTC 2018  3s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] update_settings -> [agent resp] 10
~                             Wed Apr 11 17:34:22 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] ping -> [agent resp] 2
~                             Wed Apr 11 17:34:25 UTC 2018  3s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] update_settings -> [agent resp] 10
~                             Wed Apr 11 17:34:22 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
Wed Apr 11 17:34:23 UTC 2018  Wed Apr 11 17:34:23 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] ping -> [agent resp] 2
~                             Wed Apr 11 17:34:26 UTC 2018  3s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] update_settings -> [agent resp] 10
~                             Wed Apr 11 17:34:23 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping 1
Wed Apr 11 17:34:24 UTC 2018  Wed Apr 11 17:34:24 UTC 2018  0s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] ping -> [agent resp] 2
~                             Wed Apr 11 17:34:28 UTC 2018  4s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] update_settings -> [agent resp] 12
Wed Apr 11 17:34:25 UTC 2018  Wed Apr 11 17:34:26 UTC 2018  1s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] apply -> [agent resp] 6
~                             Wed Apr 11 17:34:26 UTC 2018  1s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] apply -> [agent resp] 6
~                             Wed Apr 11 17:34:26 UTC 2018  1s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] apply -> [agent resp] 6
Wed Apr 11 17:34:26 UTC 2018  Wed Apr 11 17:34:26 UTC 2018  0s        create_missing_vm(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3)/5)  [agent req] get_state -> [agent resp] 2
~                             Wed Apr 11 17:34:27 UTC 2018  1s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] apply -> [agent resp] 6
~                             Wed Apr 11 17:34:26 UTC 2018  0s        create_missing_vm(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0)/5)  [agent req] get_state -> [agent resp] 2
~                             Wed Apr 11 17:34:26 UTC 2018  0s        create_missing_vm(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0)/5)  [agent req] get_state -> [agent resp] 2
Wed Apr 11 17:34:27 UTC 2018  Wed Apr 11 17:34:27 UTC 2018  0s        create_missing_vm(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2)/5)  [agent req] get_state -> [agent resp] 2
Wed Apr 11 17:34:28 UTC 2018  Wed Apr 11 17:34:29 UTC 2018  1s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] apply -> [agent resp] 6
Wed Apr 11 17:34:29 UTC 2018  Wed Apr 11 17:34:30 UTC 2018  1s        create_missing_vm(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1)/5)  [agent req] get_state -> [agent resp] 2
Wed Apr 11 17:34:32 UTC 2018  Wed Apr 11 17:34:33 UTC 2018  1s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] upload_blob -> [agent resp] 6
Wed Apr 11 17:34:33 UTC 2018  Wed Apr 11 17:34:53 UTC 2018  20s       canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] prepare -> [agent resp] 44
Wed Apr 11 17:34:53 UTC 2018  Wed Apr 11 17:34:54 UTC 2018  1s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] drain -> [agent resp] 6
Wed Apr 11 17:34:54 UTC 2018  Wed Apr 11 17:34:55 UTC 2018  1s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] stop -> [agent resp] 6
Wed Apr 11 17:34:55 UTC 2018  Wed Apr 11 17:34:59 UTC 2018  4s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [cpi req] create_disk -> [cpi resp] disk-1a2b08ea-9861-49f1-7e27-912a23352653 2
Wed Apr 11 17:34:59 UTC 2018  Wed Apr 11 17:35:09 UTC 2018  10s       canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [cpi req] attach_disk vm-933611f1-2097-4dff-567a-430c8a3bf450 disk-1a2b08ea-9861-49f1-7e27-912a23352653 -> [cpi resp]  2
Wed Apr 11 17:35:09 UTC 2018  Wed Apr 11 17:35:09 UTC 2018  0s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [cpi req] set_disk_metadata disk-1a2b08ea-9861-49f1-7e27-912a23352653 -> [cpi resp]  2
~                             Wed Apr 11 17:35:09 UTC 2018  0s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] ping -> [agent resp] 2
~                             Wed Apr 11 17:35:18 UTC 2018  9s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] mount_disk disk-1a2b08ea-9861-49f1-7e27-912a23352653 -> [agent resp] 22
Wed Apr 11 17:35:18 UTC 2018  Wed Apr 11 17:35:20 UTC 2018  2s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] update_settings -> [agent resp] 8
Wed Apr 11 17:35:20 UTC 2018  Wed Apr 11 17:35:21 UTC 2018  1s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] upload_blob -> [agent resp] 6
Wed Apr 11 17:35:21 UTC 2018  Wed Apr 11 17:35:28 UTC 2018  7s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] apply -> [agent resp] 16
Wed Apr 11 17:35:28 UTC 2018  Wed Apr 11 17:35:29 UTC 2018  1s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] run_script pre-start -> [agent resp] 6
Wed Apr 11 17:35:29 UTC 2018  Wed Apr 11 17:35:34 UTC 2018  5s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] start -> [agent resp] 2
Wed Apr 11 17:35:44 UTC 2018  Wed Apr 11 17:35:44 UTC 2018  0s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] get_state -> [agent resp] 2
Wed Apr 11 17:35:59 UTC 2018  Wed Apr 11 17:35:59 UTC 2018  0s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] get_state -> [agent resp] 2
Wed Apr 11 17:36:14 UTC 2018  Wed Apr 11 17:36:14 UTC 2018  0s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] get_state -> [agent resp] 2
Wed Apr 11 17:36:29 UTC 2018  Wed Apr 11 17:36:29 UTC 2018  0s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] get_state -> [agent resp] 2
~                             Wed Apr 11 17:36:30 UTC 2018  1s        canary_update(master/483520db-7be7-4b24-a7d3-40d1c92fd5d1 (0))        [agent req] run_script post-start -> [agent resp] 6
Wed Apr 11 17:36:30 UTC 2018  Wed Apr 11 17:36:30 UTC 2018  0s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] upload_blob -> [agent resp] 4
~                             Wed Apr 11 17:36:52 UTC 2018  22s       canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] prepare -> [agent resp] 48
Wed Apr 11 17:36:52 UTC 2018  Wed Apr 11 17:36:53 UTC 2018  1s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] drain -> [agent resp] 6
Wed Apr 11 17:36:53 UTC 2018  Wed Apr 11 17:36:54 UTC 2018  1s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] stop -> [agent resp] 6
Wed Apr 11 17:36:54 UTC 2018  Wed Apr 11 17:36:58 UTC 2018  4s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [cpi req] create_disk -> [cpi resp] disk-a1a2e2ce-a116-4c3b-47bb-ec9610a667cb 2
Wed Apr 11 17:36:58 UTC 2018  Wed Apr 11 17:37:08 UTC 2018  10s       canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [cpi req] attach_disk vm-2ffe814b-f1b4-4d96-62bd-50038d12911f disk-a1a2e2ce-a116-4c3b-47bb-ec9610a667cb -> [cpi resp]  2
Wed Apr 11 17:37:08 UTC 2018  Wed Apr 11 17:37:08 UTC 2018  0s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [cpi req] set_disk_metadata disk-a1a2e2ce-a116-4c3b-47bb-ec9610a667cb -> [cpi resp]  2
~                             Wed Apr 11 17:37:08 UTC 2018  0s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] ping -> [agent resp] 2
~                             Wed Apr 11 17:37:17 UTC 2018  9s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] mount_disk disk-a1a2e2ce-a116-4c3b-47bb-ec9610a667cb -> [agent resp] 22
Wed Apr 11 17:37:17 UTC 2018  Wed Apr 11 17:37:20 UTC 2018  3s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] update_settings -> [agent resp] 10
Wed Apr 11 17:37:20 UTC 2018  Wed Apr 11 17:37:21 UTC 2018  1s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] upload_blob -> [agent resp] 6
Wed Apr 11 17:37:21 UTC 2018  Wed Apr 11 17:37:27 UTC 2018  6s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] apply -> [agent resp] 16
Wed Apr 11 17:37:27 UTC 2018  Wed Apr 11 17:37:28 UTC 2018  1s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] run_script pre-start -> [agent resp] 6
Wed Apr 11 17:37:28 UTC 2018  Wed Apr 11 17:37:33 UTC 2018  5s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] start -> [agent resp] 2
Wed Apr 11 17:37:43 UTC 2018  Wed Apr 11 17:37:43 UTC 2018  0s        canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] get_state -> [agent resp] 2
~                             Wed Apr 11 17:37:57 UTC 2018  14s       canary_update(worker/896727bf-8aef-4406-98f0-0bfc57a60fc7 (0))        [agent req] run_script post-start -> [agent resp] 32
Wed Apr 11 17:37:57 UTC 2018  Wed Apr 11 17:37:58 UTC 2018  1s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] upload_blob -> [agent resp] 6
Wed Apr 11 17:37:58 UTC 2018  Wed Apr 11 17:38:21 UTC 2018  23s       instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] prepare -> [agent resp] 48
Wed Apr 11 17:38:21 UTC 2018  Wed Apr 11 17:38:22 UTC 2018  1s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] drain -> [agent resp] 6
Wed Apr 11 17:38:22 UTC 2018  Wed Apr 11 17:38:23 UTC 2018  1s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] stop -> [agent resp] 6
Wed Apr 11 17:38:23 UTC 2018  Wed Apr 11 17:38:26 UTC 2018  3s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [cpi req] create_disk -> [cpi resp] disk-35b999b0-31b6-4b36-4624-3c37f23a171c 2
Wed Apr 11 17:38:26 UTC 2018  Wed Apr 11 17:38:40 UTC 2018  14s       instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [cpi req] attach_disk vm-dcaad1de-94fb-4a47-6317-777b72ce7263 disk-35b999b0-31b6-4b36-4624-3c37f23a171c -> [cpi resp]  2
Wed Apr 11 17:38:40 UTC 2018  Wed Apr 11 17:38:40 UTC 2018  0s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [cpi req] set_disk_metadata disk-35b999b0-31b6-4b36-4624-3c37f23a171c -> [cpi resp]  2
~                             Wed Apr 11 17:38:40 UTC 2018  0s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] ping -> [agent resp] 2
~                             Wed Apr 11 17:38:50 UTC 2018  10s       instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] mount_disk disk-35b999b0-31b6-4b36-4624-3c37f23a171c -> [agent resp] 22
Wed Apr 11 17:38:50 UTC 2018  Wed Apr 11 17:38:52 UTC 2018  2s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] update_settings -> [agent resp] 8
Wed Apr 11 17:38:52 UTC 2018  Wed Apr 11 17:38:52 UTC 2018  0s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] upload_blob -> [agent resp] 4
~                             Wed Apr 11 17:38:58 UTC 2018  6s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] apply -> [agent resp] 16
Wed Apr 11 17:38:58 UTC 2018  Wed Apr 11 17:38:59 UTC 2018  1s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] run_script pre-start -> [agent resp] 6
Wed Apr 11 17:38:59 UTC 2018  Wed Apr 11 17:39:04 UTC 2018  5s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] start -> [agent resp] 2
Wed Apr 11 17:39:14 UTC 2018  Wed Apr 11 17:39:14 UTC 2018  0s        instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] get_state -> [agent resp] 2
~                             Wed Apr 11 17:39:26 UTC 2018  12s       instance_update(worker/2c7e3d2f-85d8-401c-82f0-98b9aeecb38f (3))      [agent req] run_script post-start -> [agent resp] 28
Wed Apr 11 17:39:26 UTC 2018  Wed Apr 11 17:39:26 UTC 2018  0s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] upload_blob -> [agent resp] 4
~                             Wed Apr 11 17:39:51 UTC 2018  25s       instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] prepare -> [agent resp] 54
Wed Apr 11 17:39:51 UTC 2018  Wed Apr 11 17:39:52 UTC 2018  1s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] drain -> [agent resp] 6
Wed Apr 11 17:39:52 UTC 2018  Wed Apr 11 17:39:53 UTC 2018  1s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] stop -> [agent resp] 6
Wed Apr 11 17:39:57 UTC 2018  Wed Apr 11 17:40:07 UTC 2018  10s       instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [cpi req] attach_disk vm-ee2c2932-f754-46f8-50ff-eae21e23bc43 disk-d427bfa9-8000-47fc-6dee-5b5b70cc6696 -> [cpi resp]  2
Wed Apr 11 17:40:07 UTC 2018  Wed Apr 11 17:40:07 UTC 2018  0s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [cpi req] set_disk_metadata disk-d427bfa9-8000-47fc-6dee-5b5b70cc6696 -> [cpi resp]  2
~                             Wed Apr 11 17:40:07 UTC 2018  0s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] ping -> [agent resp] 2
~                             Wed Apr 11 17:40:17 UTC 2018  10s       instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] mount_disk disk-d427bfa9-8000-47fc-6dee-5b5b70cc6696 -> [agent resp] 24
Wed Apr 11 17:40:17 UTC 2018  Wed Apr 11 17:40:21 UTC 2018  4s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] update_settings -> [agent resp] 12
Wed Apr 11 17:40:21 UTC 2018  Wed Apr 11 17:40:22 UTC 2018  1s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] upload_blob -> [agent resp] 6
Wed Apr 11 17:40:22 UTC 2018  Wed Apr 11 17:40:28 UTC 2018  6s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] apply -> [agent resp] 16
Wed Apr 11 17:40:28 UTC 2018  Wed Apr 11 17:40:30 UTC 2018  2s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] run_script pre-start -> [agent resp] 6
Wed Apr 11 17:40:30 UTC 2018  Wed Apr 11 17:40:35 UTC 2018  5s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] start -> [agent resp] 2
Wed Apr 11 17:40:45 UTC 2018  Wed Apr 11 17:40:45 UTC 2018  0s        instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] get_state -> [agent resp] 2
~                             Wed Apr 11 17:40:59 UTC 2018  14s       instance_update(worker/522ab34c-bb48-45b4-b634-afd07466e88f (1))      [agent req] run_script post-start -> [agent resp] 32
Wed Apr 11 17:40:59 UTC 2018  Wed Apr 11 17:41:00 UTC 2018  1s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] upload_blob -> [agent resp] 6
Wed Apr 11 17:41:00 UTC 2018  Wed Apr 11 17:41:22 UTC 2018  22s       instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] prepare -> [agent resp] 48
Wed Apr 11 17:41:22 UTC 2018  Wed Apr 11 17:41:23 UTC 2018  1s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] drain -> [agent resp] 6
Wed Apr 11 17:41:23 UTC 2018  Wed Apr 11 17:41:24 UTC 2018  1s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] stop -> [agent resp] 6
Wed Apr 11 17:41:24 UTC 2018  Wed Apr 11 17:41:27 UTC 2018  3s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [cpi req] create_disk -> [cpi resp] disk-2ea924bf-f819-4c8e-54a0-3fefd2ece366 2
Wed Apr 11 17:41:28 UTC 2018  Wed Apr 11 17:41:38 UTC 2018  10s       instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [cpi req] attach_disk vm-0eb7f462-67fb-47af-741f-8306e13e1fcc disk-2ea924bf-f819-4c8e-54a0-3fefd2ece366 -> [cpi resp]  2
Wed Apr 11 17:41:38 UTC 2018  Wed Apr 11 17:41:38 UTC 2018  0s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [cpi req] set_disk_metadata disk-2ea924bf-f819-4c8e-54a0-3fefd2ece366 -> [cpi resp]  2
~                             Wed Apr 11 17:41:38 UTC 2018  0s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] ping -> [agent resp] 2
~                             Wed Apr 11 17:41:47 UTC 2018  9s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] mount_disk disk-2ea924bf-f819-4c8e-54a0-3fefd2ece366 -> [agent resp] 22
Wed Apr 11 17:41:47 UTC 2018  Wed Apr 11 17:41:50 UTC 2018  3s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] update_settings -> [agent resp] 10
Wed Apr 11 17:41:50 UTC 2018  Wed Apr 11 17:41:50 UTC 2018  0s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] upload_blob -> [agent resp] 4
~                             Wed Apr 11 17:41:56 UTC 2018  6s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] apply -> [agent resp] 16
Wed Apr 11 17:41:56 UTC 2018  Wed Apr 11 17:41:57 UTC 2018  1s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] run_script pre-start -> [agent resp] 6
Wed Apr 11 17:41:57 UTC 2018  Wed Apr 11 17:42:02 UTC 2018  5s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] start -> [agent resp] 2
Wed Apr 11 17:42:12 UTC 2018  Wed Apr 11 17:42:12 UTC 2018  0s        instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] get_state -> [agent resp] 2
~                             Wed Apr 11 17:42:23 UTC 2018  11s       instance_update(worker/a3c5f10b-3372-48a2-8a3d-3417e17328d0 (2))      [agent req] run_script post-start -> [agent resp] 26
Wed Apr 11 17:42:23 UTC 2018  Wed Apr 11 17:42:44 UTC 2018  21s       -                                                                     [agent req] run_script post-deploy -> [agent resp] 44
~                             Wed Apr 11 17:42:23 UTC 2018  0s        -                                                                     [agent req] run_script post-deploy -> [agent resp] 4
~                             Wed Apr 11 17:42:23 UTC 2018  0s        -                                                                     [agent req] run_script post-deploy -> [agent resp] 4
~                             Wed Apr 11 17:42:23 UTC 2018  0s        -                                                                     [agent req] run_script post-deploy -> [agent resp] 4
~                             Wed Apr 11 17:42:23 UTC 2018  0s        -                                                                     [agent req] run_script post-deploy -> [agent resp] 4
Wed Apr 11 17:42:44 UTC 2018  Wed Apr 11 17:42:44 UTC 2018  0s        task:4880                                                             [agent req]  1
```
