# xd7mastercontroller #

This modules install an enterprise production grade Citrix 7.x Delivery Controller, including Citrix site creation and administrator rights setup.

The following options are available for a production-grade installation :
- Fault tolerance : AlwaysOn database membership activation for Citrix databases created by the package
- Sécurity : SSL configuration to secure communications with the Citrix XML Broker Service

## Integration informations
The Citrix databases will be installed in the default MSSQLSERVER SQL Server instance. This module does not provide the capability to install the databases in another SQL intance.

The database failover mecanism integrated in this module is SQL Server AlwaysOn.

The SSL certificate provided needs to be a password protected p12/pfx certificate including the private key.

The module can be installed on a Standard, Datacenter version of Windows 2012R2 or Windows 2016. **Core version is not supported by Citrix for delivery Controller installation**.

Migrated puppet example code in README.md to future parser syntax (4.x). Impact on parameters refering to remote locations (file shares) which have to be prefixed with \\\\ instead of the classical \\. This is because of Puppet >= 4.x parsing \\ as a single \ in single-quoted strings. Use parser = future in puppet 3.x /etc/puppet/puppet.conf to use this new configuration in your Puppet 3.x and prepare Puppet 4.x migration.

## Usage
- **svc_username** : (string) Privileged account used by Puppet for installing the software and the Xendesktop Site (cred_ssp server and client, SQL server write access, local administrator privilèges needed)
- **svc_password** : (string) Password of the privileged account. Should be encrypted with hiera-eyaml.
- **sitename** : (string) Name of the Xendesktop site
- **databaseserver** : (string) FQDN of the SQL server used for citrix database hosting. If using a AlwaysOn SQL cluster, use the Listener FQDN.
- **licenceserver** : (string) FQDN of the Citrix Licence server.
- **sitedatabasename** : (string) Name of the citrix site database to be created
- **loggingdatabasename** : (string) Name of the citrix logging database to be created
- **monitordatabasename** : (string) Name of the citrix monitor database to be created
- **sourcepath** : (string) Path of a folder containing the Xendesktop 7.x installer (unarchive the ISO image in this folder). Has to be prefixed with \\\\ instead of the classical \\ if using UNC Path and Puppet >= 4.x or Puppet 3.x future parser.
- **xd7administrator** : (string) ActiveDirectory user or group which will be granted Citrix Administrator rights.
- **sqlalwayson** : (boolean) : true or false. Activate database AlwaysOn availability group membership ? Default is false. Needs to be true for a production grade environment
- **sqlavailabilitygroup** : (string) (optionnal if sqlalwayson = false) : Name of the SQL AlwaysOn availability group.
- **sqldbbackuppath** :  (string) (optionnal if sqlalwayson = false) : UNC path of a writable network folder to backup/restore databases during AlwaysOn availability group membership configuration. needs to be writable from the sql server nodes. Has to be prefixed with \\\\ instead of the classical \\ if using Puppet >= 4.x or Puppet 3.x future parser.
- **https** : (boolean) : true or false. Deploy SSL certificate and activate SSL access to Citrix XML service ? Default : false
- **sslCertificateSourcePath** : (string) Location of the SSL certificate (p12 / PFX format with private key). Can be local folder, UNC path, HTTP URL). Has to be prefixed with \\\\ instead of the classical \\ if using UNC Path and Puppet >= 4.x or Puppet 3.x future parser.
- **sslCertificatePassword** : (string) Password protecting the p12/pfx SSL certificate file.
- **sslCertificateThumbprint** : (string) Thumbprint of the SSL certificate (available in the SSL certificate).

## Installing a Citrix Delivery Controller

~~~puppet
node 'CXDC' {
	class{'xd7mastercontroller':
	  svc_username => 'TESTLAB\svc-puppet',
	  svc_password => 'P@ssw0rd',
	  sitename => 'XD7TestSite',
	  databaseserver => 'CLSDB01LI.TESTLAB.COM',
	  licenceserver => 'LICENCE.TESTLAB.COM',
	  sitedatabasename => 'SITE_DB',
	  loggingdatabasename => 'LOG_DB',
	  monitordatabasename => 'MONITOR_DB',
	  sourcepath => '\\\\fileserver\xendesktop715',
	  xd7administrator => 'TESTLAB\Domain Admins',
	  sqlalwayson => true,
	  sqlavailabilitygroup => 'CLSDB01',
	  sqldbbackuppath => '\\\\fileserver\backup\sql',
	  https => true,
	  sslCertificateSourcePath => '\\\\fileserver\ssl\cxdc.pfx',
	  sslCertificatePassword => 'P@ssw0rd',
	  sslCertificateThumbprint => '44cce73845feef4da4d369a37386c862eb3bd4e1'  
	}
}
~~~
