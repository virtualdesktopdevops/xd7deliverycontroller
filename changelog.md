# Changelog - xd7mastercontroller #

## Unreleased
- **BREAKING CHANGE** : Require puppetlabs/dsc compiled with SQLServerDSC = 10.0.0.0
- **BREAKING CHANGE** : Removed unneeded $domainNetbiosName parameter.
- **BREAKING CHANGE** : Migrated puppet example code in README.md to future parser syntax (4.x). Impact on parameters refering to remote locations (file shares) which have to be prefixed with \\\\ instead of the classical \\. This is because of Puppet >= 4.x parsing \\ as a single \ in single-quoted strings. Use parser = future in puppet 3.x /etc/puppet/puppet.conf to use this new configuration in your Puppet 3.x and prepare Puppet 4.x migration.

## Version 1.1.0
- Initial release
- Module compatible with xSQLServer <= 9.0.0.0
