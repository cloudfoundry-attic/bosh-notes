
## Default deployment manifest in release

If release provide some default manifest extract is to provide default deployments for the release.

# List of elements in default manifest

- cloud-config if needed
- types of plans/vm-types


# Pros:
- will remove requirement of ODB for services
- allow easy and flixible intraction with BOSH
- easy implementation

# Cons:
- more load on BOSH to maintain plans and deployment types

