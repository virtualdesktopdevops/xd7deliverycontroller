# Changelog - xd7deliverycontroller #

## Version 2.0.0 ##
- **BREAKING CHANGE** : Merged **xd7mastercontroller** and **xd7slavecontroller** into **xd7deliverycontroller**. Added a **role** parameter to install a **primary** controller with XenDesktop site creation or a **secondary**  controller joined to an existing XenDesktop site.
- **BREAKING CHANGE** : Require virtualdesktopdevops/dsc >= 1.5.0 (puppetlabs/dsc fork compiled with XenDesktop7 DSC resource)
- **BREAKING CHANGE** : Removed unneeded $domainNetbiosName parameter.
- **BREAKING CHANGE** : Migrated puppet example code in README.md to future parser syntax (4.x). Impact on parameters refering to remote locations (file shares) which have to be prefixed with \\\\ instead of the classical \\. This is because of Puppet >= 4.x parsing \\ as a single \ in single-quoted strings. Use parser = future in puppet 3.x /etc/puppet/puppet.conf to use this new configuration in your Puppet 3.x and prepare Puppet 4.x migration.
- **BREAKING CHANGE** : Changed all module parameters to lowercase to comply with puppet guidelines.
- **BREAKING CHANGE** : Removed SQLServer Powershell resource from the module. Added **sqlservermodulesource** and **sqlservermodulesourcepath** parameters to install is from the internet or from an enterprise file share.
- Compliance with puppet language style guide and puppet forge standards.
- Class parameters data types.



## Version 1.1.0 ##
- Initial release
- Module compatible with xSQLServer <= 9.0.0.0
