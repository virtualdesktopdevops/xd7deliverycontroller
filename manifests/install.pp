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

}
