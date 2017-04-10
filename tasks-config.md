## Tasks config

```
$ bosh tasks-config
---
tasks:
- options:
		rate_limit: 0
	include:
		deployment:
			- some-name
	exclude:
		deployment:
			- ads

	- include: ...
		priority: 1

	- include: ...


  # pause, rate_limit, prioirty (queue?)
	rules:
	- type: prioiritize
	  level: red
		include:
		  deployment: []
		  teams: [...]
		  user: [...]

	- type: pause
		include:
		  deployment: []
		  teams: [...]
		  user: [...]
		exclude:
		  ...

	- type: rate_limit
	  workers: 3 # only 3 workers can work on tasks matching
	  include:
		  deployment: []
		  teams: [...]
```
