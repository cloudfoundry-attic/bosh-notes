# Job Lifecycle [PLANNING]

Use cases:

- db migration
- route_registrar example
- uaa taking long time to start
- consul joining
- consul switching versions

## Actions

- pre-start (already implemented)
  - runs on each instance before monit starts processes
- post-start
  - runs on each instance after monit claims that processes are running
  - examples:
    - concourse: wait for a process to connect to a DB successfully
    - garden: wait for server to become pingable
- drain (already implemented)
  - runs on each instance before monit stops processes

## ...

- post-job-deploy?
  - runs on each instance after a deployment finishes
  - accounts for canaries and max_in_flight?s
  - naming
- post-deploy
  - runs on each instance after the deploy has finished
  - accounts for canaries and max_in_flight?

## TBD

- single VM colocation vs multi VM behavior
- what happens after resurrection?
- ordering of jobs in the deployment manifest
- ordering of job scripts (ipsec)
