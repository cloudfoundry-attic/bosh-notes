- State: in-progress

## Resurrection config

```
$ bosh resurrection-config
---
resurrection:
- options:
		enabled: false
	include:
		deployment:
			- some-name
	exclude:
		deployment:
			- ads

- options:
		enabled: true
	include:
		deployment:
			- some-name
		jobs:
		  - name: foo
		    release: foo

- options:
    enabled: true
  deployment:
    jobs:
    	- name: foo
    		release: foo
```
