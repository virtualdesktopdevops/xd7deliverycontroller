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

	#Ensure IIS is not installed on the system to avoid conflicts with Broker Service
	dsc_windowsfeature{'iis':
	 dsc_ensure => 'Absent',
	 dsc_name   => 'Web-Server',
	}

  #Install Delivery Controller
	dsc_xd7features { 'XD7DeliveryController':
	 dsc_issingleinstance => 'Yes',
	 dsc_role => ['Studio', 'Controller'],
	 dsc_sourcepath => $sourcepath,
	 dsc_ensure => 'present',
	 require => Dsc_windowsfeature['iis'],
	 notify => Reboot['after_run']
	}

	#Download and install SQLSERVER powershell module. Required for database high availability setup (always on citrix databases membership)
	file{ "C:\\Program Files\\WindowsPowerShell\\Modules\\sqlserver_powershell_21.0.17199.zip":
	 source => 'puppet:///modules/xd7mastercontroller/sqlserver_powershell_21.0.17199.zip',
	 source_permissions => ignore,
	}

  #dsc_xarchive{'UnzipSqlserverModule':
	#  dsc_path  => 'C:\Program Files\WindowsPowerShell\Modules\sqlserver_powershell_21.0.17199.zip',
	#  dsc_destination => 'C:\Program Files\WindowsPowerShell\Modules',
	#  dsc_force => true,
	#  require => File["C:\\Program Files\\WindowsPowerShell\\Modules\\sqlserver_powershell_21.0.17199.zip"]
  #}

	#Unzip function provided by the reidmv-unzip
	unzip{'UnzipSqlserverModule':
	 source  => 'C:\\Program Files\WindowsPowerShell\Modules\sqlserver_powershell_21.0.17199.zip',
	 destination => 'C:\\Program Files\WindowsPowerShell\Modules',
	 creates => 'C:\\Program Files\WindowsPowerShell\Modules\SqlServer',
	 require => File["C:\\Program Files\\WindowsPowerShell\\Modules\\sqlserver_powershell_21.0.17199.zip"]
	}

}
