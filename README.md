## bosh-notes

This repository contains collection of *proposals* for [BOSH](https://github.com/cloudfoundry/bosh).

*** For actually implemented features and documentation, please see [bosh.io/docs](https://bosh.io/docs) ***

You can also find currently in progress work in the Epics view in each Tracker:

- [BOSH Core](https://www.pivotaltracker.com/n/projects/956238)
- [BOSH CPI](https://www.pivotaltracker.com/n/projects/1133984)
- [BOSH OpenStack CPI](https://www.pivotaltracker.com/n/projects/1456570)
- [BOSH Windows](https://www.pivotaltracker.com/n/projects/1479998)

### Process

- Check existing proposal for duplicate ideas
- Submit a PR with your proposal (`proposals/` directory)
  - Include details about use cases, possible solutions, problems, related proposals, etc.
- Proposal will go through different states
  - `discussing`
  - `rejected` when rejected
  - `accepted` when accepted
  - `in-progress` when implementation starts
  - `finished` when completed
- Certain portions of a proposal may be left out of initial implementation hence new proposal should be formed
  - Use `-vX` (-v2) suffix for continuation

## Development

```
./summarize.rb > summary.md
```