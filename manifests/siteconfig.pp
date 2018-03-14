#Class for Citrix XenDesktop site initial configuration
class xd7mastercontroller::siteconfig inherits xd7mastercontroller {

  #Databases creation
  dsc_xd7database{ 'XD7SiteDatabase':
    dsc_sitename             => $xd7mastercontroller::sitename,
    dsc_databaseserver       => $xd7mastercontroller::databaseserver,
    dsc_databasename         => $xd7mastercontroller::sitedatabasename,
    dsc_datastore            => 'Site',
    dsc_psdscrunascredential => {
      'user'     => $xd7mastercontroller::setup_svc_username,
      'password' => $xd7mastercontroller::setup_svc_password
      },
  }

  dsc_xd7database{ 'XD7SiteLoggingDatabase':
    dsc_sitename             => $xd7mastercontroller::sitename,
    dsc_databaseserver       => $xd7mastercontroller::databaseserver,
    dsc_databasename         => $xd7mastercontroller::loggingdatabasename,
    dsc_datastore            => 'Logging',
    dsc_psdscrunascredential => {
      'user'     => $xd7mastercontroller::setup_svc_username,
      'password' => $xd7mastercontroller::setup_svc_password
      },
  }

  dsc_xd7database{ 'XD7SiteMonitorDatabase':
    dsc_sitename             => $xd7mastercontroller::sitename,
    dsc_databaseserver       => $xd7mastercontroller::databaseserver,
    dsc_databasename         => $xd7mastercontroller::monitordatabasename,
    dsc_datastore            => 'Monitor',
    dsc_psdscrunascredential => {
      'user'     => $xd7mastercontroller::setup_svc_username,
      'password' => $xd7mastercontroller::setup_svc_password
      },
  }

  #XD7 site creation
  dsc_xd7site{ 'XD7Site':
    dsc_sitename             => $xd7mastercontroller::sitename,
    dsc_databaseserver       => $xd7mastercontroller::databaseserver,
    dsc_sitedatabasename     => $xd7mastercontroller::sitedatabasename,
    dsc_loggingdatabasename  => $xd7mastercontroller::loggingdatabasename,
    dsc_monitordatabasename  => $xd7mastercontroller::monitordatabasename,
    dsc_psdscrunascredential => {
      'user'     => $xd7mastercontroller::setup_svc_username,
      'password' => $xd7mastercontroller::setup_svc_password
      },
    require                  => [
      Dsc_xd7database['XD7SiteDatabase'],
      Dsc_xd7database['XD7SiteMonitorDatabase'],
      Dsc_xd7database['XD7SiteLoggingDatabase'] ]
  }

  #Linking with Citrix License server
  dsc_xd7sitelicense{ 'XD7SiteLicense':
    dsc_licenseserver                 => $xd7mastercontroller::licenceserver,
    dsc_licenseedition                => 'PLT',
    dsc_licensemodel                  => 'UserDevice',
    dsc_trustlicenseservercertificate => false,
    dsc_psdscrunascredential          => {
      'user'     => $xd7mastercontroller::setup_svc_username,
      'password' => $xd7mastercontroller::setup_svc_password
      },
    require                           => Dsc_xd7site['XD7Site']
  }

  #Site admin roles for users
  #Administrator has to be created before beeing affected a role
  dsc_xd7administrator{ 'CitrixAdmin':
    dsc_name                 => $xd7mastercontroller::xd7administrator,
    dsc_psdscrunascredential => {
      'user'     => $xd7mastercontroller::setup_svc_username,
      'password' => $xd7mastercontroller::setup_svc_password
      },
    require                  => Dsc_xd7site['XD7Site']
  }

  dsc_xd7role{ 'CitrixAdminFullAdministratorRole':
    dsc_name                 => 'Full Administrator',
    dsc_members              => $xd7mastercontroller::xd7administrator,
    dsc_psdscrunascredential => {
      'user'     => $xd7mastercontroller::setup_svc_username,
      'password' => $xd7mastercontroller::setup_svc_password
      },
    require                  => [ Dsc_xd7site['XD7Site'] , Dsc_xd7administrator['CitrixAdmin'] ]
  }

  #Site admin roles for Puppet service account
  #Administrator has to be created before beeing affected a role
  dsc_xd7administrator{ 'PuppetServiceAccountCitrixAdmin':
    dsc_name                 => $xd7mastercontroller::setup_svc_username,
    dsc_psdscrunascredential => {
      'user'     => $xd7mastercontroller::setup_svc_username,
      'password' => $xd7mastercontroller::setup_svc_password
      },
    require                  => Dsc_xd7site['XD7Site']
  }

  dsc_xd7role{ 'PuppetServiceAccountFullAdministratorRole':
    dsc_name                 => 'Full Administrator',
    dsc_members              => $xd7mastercontroller::setup_svc_username,
    dsc_psdscrunascredential => {
      'user'     => $xd7mastercontroller::setup_svc_username,
      'password' => $xd7mastercontroller::setup_svc_password
      },
    require                  => [ Dsc_xd7site['XD7Site'] , Dsc_xd7administrator['PuppetServiceAccountCitrixAdmin'] ]
  }

  #Trust requests sent to XML service
  dsc_xd7siteconfig{'XD7GlobalSiteSetting':
    dsc_issingleinstance                     => 'Yes',
    dsc_trustrequestssenttothexmlserviceport => true,
    dsc_psdscrunascredential                 => {
      'user'     => $xd7mastercontroller::setup_svc_username,
      'password' => $xd7mastercontroller::setup_svc_password
      },
    require                                  => Dsc_xd7site['XD7Site']
  }
}
