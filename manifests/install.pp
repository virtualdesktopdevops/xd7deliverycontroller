#Class installing Citrix XenDesktop Delivery Controller and SQLServer powershell module
class xd7mastercontroller::install inherits xd7mastercontroller {

  reboot { 'after_run':
    apply => immediately,
    when  => refreshed
  }

  #Implemented a GPO check to prevent an endless reboot loop when CredSSP is configured via a GPO
  if (!$facts['credsspservicegpo']) {
    dsc_xcredssp{ 'Server':
      dsc_ensure => 'Present',
      dsc_role   => 'Server',
      notify     => Reboot['after_run']
    }
  }
  else {
    notify { 'CredSSPServiceAlreadyConfigured':
    message => 'CredSSP already configured by GPO. Unauthorized to overide GPO configuration.
      Please check that CredSSP service is allowed on this Computer.'
    }
  }

  #Implemented a GPO check to prevent an endless reboot loop when CredSSP is configured via a GPO
  if (!$facts['credsspclientgpo']) {
    dsc_xcredssp{ 'Client':
      dsc_ensure            => 'Present',
      dsc_role              => 'Client',
      dsc_delegatecomputers => '*'
    }
  }
  else {
    notify { 'CredSSPClientAlreadyConfigured':
      message => 'CredSSP already configured by GPO. Unauthorized to overide GPO configuration.
        Please check that CredSSP client is allowed on this Computer.'
    }
  }

  #Ensure IIS is not installed on the system to avoid conflicts with Broker Service
  dsc_windowsfeature{'iis':
    dsc_ensure => 'Absent',
    dsc_name   => 'Web-Server',
  }

  #Install Delivery Controller
  dsc_xd7features { 'XD7DeliveryController':
    dsc_issingleinstance => 'Yes',
    dsc_role             => ['Studio', 'Controller'],
    dsc_sourcepath       => $xd7mastercontroller::sourcepath,
    dsc_ensure           => 'present',
    require              => Dsc_windowsfeature['iis'],
    notify               => Reboot['after_run']
  }

  #Download and install SQLSERVER powershell module. Required for database high availability setup (always on citrix databases membership)
  if ($xd7mastercontroller::sqlservermodulesource == 'internet') {
    exec { 'InstallNuGetProviderPSGallery':
      command  => 'Install-PackageProvider -Name NuGet -Confirm:$false -Force',
      onlyif   => 'if (Get-PackageProvider -ListAvailable -Name Nuget) { exit 1 }',
      provider => 'powershell'
    }

    ->exec { 'InstallSQLServerModulePSGallery':
      command  => 'Install-Module -Name SqlServer -RequiredVersion 21.0.17099 -Confirm:$false -Force',
      onlyif   => 'if (Get-Module -ListAvailable -Name SqlServer) { exit 1 }',
      provider => 'powershell'
    }
  }
  else {
    file{ 'C:\Program Files\WindowsPowerShell\Modules\sqlserver_powershell_module.zip':
      source             => $xd7mastercontroller::sqlservermodulesourcepath,
      source_permissions => ignore,
    }

    #Unzip function provided by the reidmv-unzip
    ->unzip{'UnzipSqlserverModule':
      source      => 'C:\Program Files\WindowsPowerShell\Modules\sqlserver_powershell_module.zip',
      destination => 'C:\Program Files\WindowsPowerShell\Modules',
      creates     => 'C:\Program Files\WindowsPowerShell\Modules\SqlServer'
    }
  }
}
