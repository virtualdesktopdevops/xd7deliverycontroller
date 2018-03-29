# Citrix XenDesktop 7 delivery controller Puppet Module #

Puppet module installing a production grade Citrix XenDesktop 7.x Delivery Controller, including XenDesktop site creation, high availability configuration and administrator rights setup.

The following options are available for a production-grade installation :
- Fault tolerance : AlwaysOn database membership activation for Citrix databases created by the package
- Sécurity : SSL configuration to secure communications with the Citrix XML Broker Service

## Requirements ##

The minimum Windows Management Framework (PowerShell) version required is 5.0 or higher, which ships with Windows 10 or Windows Server 2016, but can also be installed on Windows 7 SP1, Windows 8.1, Windows Server 2008 R2 SP1, Windows Server 2012 and Windows Server 2012 R2.

This module requires SQLServer powershell module v21.0.17199. The module will install this dependancy :
- From Powershell Gallery if **sqlservermodulesource** parameter is set to **internet**
- From an enterprise location if **sqlservermodulesource** parameter is set to **offline**. In this case, the ZIP file containing the SQLServer v21.0.17199 (_sqlserver_powershell_21.0.17199.zip_) has to be manually downloaded from Powershell Gallery using the `Save-Module -Name SqlServer -Path <path> -RequiredVersion 21.0.17199` powershell command.

This module requires a custom version of the puppetlabs-dsc module compiled with [XenDesktop Powershell DSC Resource](https://github.com/VirtualEngine/XenDesktop7) as a dependency. Ready to use virtualdesktopdevops/dsc v1.5.0 puppet module provided on [Puppet Forge](https://forge.puppet.com/virtualdesktopdevops/dsc).

## Change log ##

A full list of changes in each version can be found in the [change log](CHANGELOG.md).

## Integration informations ##
The Citrix databases will be installed in the default MSSQLSERVER SQL Server instance. This module does not provide the capability to install the databases in another SQL intance.

The database failover mecanism integrated in this module is SQL Server AlwaysOn.

The SSL certificate provided needs to be a password protected p12/pfx certificate including the private key.

The module can be installed on a Standard, Datacenter version of Windows 2012R2 or Windows 2016. **Core version is not supported by Citrix for delivery Controller installation**.

Migrated puppet example code in README.md to future parser syntax (4.x). Impact on parameters refering to remote locations (file shares) which have to be prefixed with \\\\ instead of the classical \\. This is because of Puppet >= 4.x parsing \\ as a single \ in single-quoted strings. Use parser = future in puppet 3.x /etc/puppet/puppet.conf to use this new configuration in your Puppet 3.x and prepare Puppet 4.x migration.

## Usage ##
**Mandatory parameters :**
* **`[String]` setup_svc_username** _(Required)_: Privileged account used by Puppet for installing the software and the Xendesktop Site (cred_ssp server and client, SQL server write access, local administrator privilèges needed)
- **`[String]` setup_svc_password** _(Required)_: Password of the privileged account. Should be encrypted with hiera-eyaml.
- **`[String]` sourcepath** _(Required)_: Path of a folder containing the Xendesktop 7.x installer (unarchive the ISO image in this folder). Has to be prefixed with \\\\ instead of the classical \\ if using UNC Path and Puppet >= 4.x or Puppet 3.x future parser.
- **`[String]` sitename** _(Required)_: Name of the Xendesktop site
- **`[String]` role** _(Required `[primary|secondary]`)_: Needs to be 'primary' for the first Citrix Delivery Controller of a site to initialize the databases and the Xendesktop site. Configure as 'secondary' for all other delivery Controllers of the site as they will join an existing Xendesktop site.

**Required parameters if role='primary' :**
- **`[String]` databaseserver** _(Required if role='primary')_: FQDN of the SQL server used for citrix database hosting. If using a AlwaysOn SQL cluster, use the Listener FQDN.
- **`[String]` licenceserver** _(Required if role='primary')_: FQDN of the Citrix Licence server.
- **`[String]` xd7administrator** _(Required if role='primary')_: ActiveDirectory user or group which will be granted Citrix Administrator rights.

**Required parameters if role='secondary' :**
- **`[String]` site_primarycontroller** _(Required if role='secondary')_: Primary controller of the existing Xendesktop site to which the newly configured Delivery Controller has to be joined.

**Optional parameters :**
- **`[String]` sitedatabasename** _(Optional, default is CitrixSiteDB)_: Name of the citrix site database to be created
- **`[String]` loggingdatabasename** _(Optional, default is CitrixLogDB)_: Name of the citrix logging database to be created
- **`[String]` monitordatabasename** _(Optional, default is CitrixMonitorDB)_: Name of the citrix monitor database to be created
- **`[Boolean]` sqlalwayson** _(Optional, default is false)_: Activate database AlwaysOn availability group membership ? Default is false. Needs to be true for a production grade environment
- **`[String]` sqlavailabilitygroup** _(Required if sqlalwayson = true)_: Name of the SQL AlwaysOn availability group.
- **`[String]` sqldbbackuppath** _(Required if sqlalwayson = true)_: UNC path of a writable network folder to backup/restore databases during AlwaysOn availability group membership configuration. needs to be writable from the sql server nodes. Has to be prefixed with \\\\ instead of the classical \\ if using Puppet >= 4.x or Puppet 3.x future parser.
* **`[String]` sqlservermodulesource** _(Optional, `[internet|offline]`)_: Source of SQLServer Powershell module v21.0.17199 (see requirements at the beginning of this readme).  Valid values are **internet** or **offline**. Default is 'internet'.
* **`[String]` sqlservermodulesourcepath** _(Required if sqlservermodulesource = 'offline' )_: Path of the SQLServer Powershell module v21.0.17199 ZIP file. Can be a local or an UNC path.
- **`[Boolean]` https** _(Optional, default is false)_: Deploy SSL certificate and activate SSL access to Citrix XML service ? Default : false
- **`[String]` sslCertificateSourcePath** _(Required if https = true)_: Location of the SSL certificate (p12 / PFX format with private key). Can be local folder, UNC path, HTTP URL). Has to be prefixed with \\\\ instead of the classical \\ if using UNC Path and Puppet >= 4.x or Puppet 3.x future parser.
- **`[String]` sslCertificatePassword** _(Required if https = true)_: Password protecting the p12/pfx SSL certificate file.
- **`[String]` sslCertificateThumbprint** _(Required if https = true)_: Thumbprint of the SSL certificate (available in the SSL certificate).

## Installing a Citrix Delivery Controller ##

~~~puppet
node 'CXDC01' {
	class{'xd7deliverycontroller':
		setup_svc_username       => 'TESTLAB\svc-puppet',
		setup_svc_password       => 'P@ssw0rd',
		sourcepath               => '\\\\fileserver\xendesktop715',
		sitename                 => 'XD7TestSite',
		role                     => 'primary'
		databaseserver           => 'CLSDB01LI.TESTLAB.COM',
		licenceserver            => 'LICENCE.TESTLAB.COM',
		xd7administrator         => 'TESTLAB\Domain Admins',
		sitedatabasename         => 'SITE_DB',
		loggingdatabasename      => 'LOG_DB',
		monitordatabasename      => 'MONITOR_DB',
		sqlalwayson              => true,
		sqlavailabilitygroup     => 'CLSDB01',
		sqldbbackuppath          => '\\\\fileserver\backup\sql',
		https                    => true,
		sslCertificateSourcePath => '\\\\fileserver\ssl\cxdc.pfx',
		sslCertificatePassword   => 'P@ssw0rd',
		sslCertificateThumbprint => '44cce73845feef4da4d369a37386c862eb3bd4e1'  
	}
}

node 'CXDC02' {
	class{'xd7deliverycontroller':
		setup_svc_username       => 'TESTLAB\svc-puppet',
		setup_svc_password       => 'P@ssw0rd',
		sourcepath               => '\\\\fileserver\xendesktop715',
		sitename                 => 'XD7TestSite',
		role                     => 'secondary',
		site_primarycontroller   => 'CXDC01',
		https                    => true,
		sslCertificateSourcePath => '\\\\fileserver\ssl\cxdc.pfx',
		sslCertificatePassword   => 'P@ssw0rd',
		sslCertificateThumbprint => '44cce73845feef4da4d369a37386c862eb3bd4e1'  
	}
}
~~~
