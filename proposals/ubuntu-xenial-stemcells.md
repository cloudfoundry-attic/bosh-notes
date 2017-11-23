- State: in-progress
- Start date: 10/23/2017
- End date: ?

# Summary

BOSH should provide Ubuntu Xenial stemcells for the community.

# Details

Next LTS version of Ubuntu is Ubuntu Xenial.

This version of Ubuntu has switched to using systemd instead of upstart.

Additionally Garden team has asked us to support 4.10 kernel so that they could try using ext4 disk quotas.

## Versioning

Since this is an entirely new stemcell line we will start it with 1.x.y convention. Major version will not be bumped as to continue supporting existing floating stemcell feature (ignores last version segment when checking if compiled packages are available). Minor version will be continiously bump as we release new versions. Patch version will be bumped when security updates are released.

# Notes

- We have disabled stable iface names in favor of using eth0 across all IaaSes
- `inetd` is gone by default (port 111)
- `pkg-config` seems to be gone as well as found out by the Garden team
