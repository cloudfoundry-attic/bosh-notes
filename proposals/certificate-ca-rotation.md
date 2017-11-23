- State: discussing
- Start date: ?
- End date: ?

# Summary

It should be possible to rotate CA certificates with the help of config server API without incurring any downtime.

# Motivation

Currently to rotate CA certificates one has to update deployment manifest to include multiple variable interpolations (eg `ca: ((cert1.ca))\n((cert2.ca))`). These manual changes are error prone and tedious. Proposed solution is to enhance config server API to simplify the workflow.

# Details

...

# TBD

- How does this relate to password rotation?
- What happens when variable options change when kicking off a deploy?
