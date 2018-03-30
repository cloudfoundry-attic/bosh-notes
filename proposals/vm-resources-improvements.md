- State: discussing
- Start date: ?
- End date: ?
- Docs: ?

# Summary

This proposal is used to keep track of suggested VM resources improvements.

# Motivation

Use cases:

- Azure CPI would like to find existing availability set to calculate VM size available in that avail set
  - Upside: better resizing experience
  - Downside: particular size selection is surprising
- AWS CPI may want to see for which AZ calculation is being done to select specific instance type that may be available
- AWS CPI may want to select particular size based on predicted number of persistent disks 
  - Azure CPI may be benefited by this as well

# Details

...

# Drawbacks

...

# Unresolved questions

...
