class xd7mastercontroller::install inherits xd7mastercontroller {
  
   reboot { 'after_run':
	  apply => immediately,
    when => refreshed
  } 
  
  dsc_xcredssp{ 'Server':
      dsc_ensure => 'Present',
      dsc_role => 'Server',
      notify => Reboot['after_run']
  }

  dsc_xcredssp{ 'Client':
      dsc_ensure => 'Present',
      dsc_role => 'Client',
      dsc_delegatecomputers => '*'
  }
  
  dsc_windowsfeature{'iis':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Server',
	}
  
  dsc_windowsfeature{'Web-Scripting-Tools':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Scripting-Tools',
	}
	
  dsc_windowsfeature{'Web-Mgmt-Console':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Mgmt-Console',
  }
  
  dsc_xd7features { 'XD7DeliveryController':
	  dsc_issingleinstance => 'Yes',
	  dsc_role => [Studio, Controller],
	  dsc_sourcepath => $sourcepath,
	  dsc_ensure => 'present',
	  require => Dsc_windowsfeature['iis'],
	  notify => Reboot['after_run']
  }
  
  #SQLSERVER powershell module deployment.
  #Required for database high awailability setup (always on citrix databases membership)
  file{ "C:\\Program Files\\WindowsPowerShell\\Modules\\sqlserver_powershell_21.0.17199.zip":
      source => 'puppet:///modules/xd7mastercontroller/sqlserver_powershell_21.0.17199.zip',
      source_permissions => ignore,
  }
  
  #Function provided by the reidmv-unzip
  unzip{'UnzipSqlserverModule':
	  source  => 'C:\\Program Files\WindowsPowerShell\Modules\sqlserver_powershell_21.0.17199.zip',
	  destination => 'C:\\Program Files\WindowsPowerShell\Modules',
	  creates => 'C:\\Program Files\WindowsPowerShell\Modules\SqlServer',
	  require => File["C:\\Program Files\\WindowsPowerShell\\Modules\\sqlserver_powershell_21.0.17199.zip"]
  }

  #Install IIS addons required for Citrix XML service offloading to IIS.
  dsc_file{ 'IISaddons':
		dsc_destinationpath => 'C:\IISaddons',
		dsc_type => 'Directory',
		dsc_ensure => 'Present'  
  }
  
  file{ "C:\\IISaddons\\iis_rewrite_amd64_en-US.msi":
		source => 'puppet:///modules/xd7mastercontroller/iis_rewrite_amd64_en-US.msi',
		source_permissions => ignore,
    require => File['IISaddons']
  }->
  
  dsc_package{'iis_rewrite_amd64_en-US':
    dsc_ensure    => 'Present',
    dsc_name      => 'IIS URL Rewrite Module 2',
    dsc_productid => '38D32370-3A31-40E9-91D0-D236F47E3C4A',
    dsc_path      => 'C:\\IISaddons\\iis_rewrite_amd64_en-US.msi',
  }
  
  file{ "C:\\IISaddons\\iis_requestRouter_amd64.msi":
    source => 'puppet:///modules/xd7mastercontroller/iis_requestRouter_amd64.msi',
    source_permissions => ignore,
    require => File['IISaddons']
  }->
  
  dsc_package{'iis_rewrite_amd64_en-US':
    dsc_ensure    => 'Present',
    dsc_name      => 'Microsoft Application Request Routing 3.0',
    dsc_productid => '279B4CB0-A213-4F94-B224-19D6F5C59942',
    dsc_path      => 'C:\\IISaddons\\iis_requestRouter_amd64.msi',
  }
  
}
