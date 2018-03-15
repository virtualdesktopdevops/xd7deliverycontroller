#Class for Citrix XenDesktop site initial configuration
class xd7deliverycontroller::siteconfig inherits xd7deliverycontroller {

  if ($xd7deliverycontroller::role == 'primary') {
    #Databases creation
    dsc_xd7database{ 'XD7SiteDatabase':
      dsc_sitename             => $xd7deliverycontroller::sitename,
      dsc_databaseserver       => $xd7deliverycontroller::databaseserver,
      dsc_databasename         => $xd7deliverycontroller::sitedatabasename,
      dsc_datastore            => 'Site',
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
    }

    dsc_xd7database{ 'XD7SiteLoggingDatabase':
      dsc_sitename             => $xd7deliverycontroller::sitename,
      dsc_databaseserver       => $xd7deliverycontroller::databaseserver,
      dsc_databasename         => $xd7deliverycontroller::loggingdatabasename,
      dsc_datastore            => 'Logging',
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
    }

    dsc_xd7database{ 'XD7SiteMonitorDatabase':
      dsc_sitename             => $xd7deliverycontroller::sitename,
      dsc_databaseserver       => $xd7deliverycontroller::databaseserver,
      dsc_databasename         => $xd7deliverycontroller::monitordatabasename,
      dsc_datastore            => 'Monitor',
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
    }

    #XD7 site creation
    dsc_xd7site{ 'XD7Site':
      dsc_sitename             => $xd7deliverycontroller::sitename,
      dsc_databaseserver       => $xd7deliverycontroller::databaseserver,
      dsc_sitedatabasename     => $xd7deliverycontroller::sitedatabasename,
      dsc_loggingdatabasename  => $xd7deliverycontroller::loggingdatabasename,
      dsc_monitordatabasename  => $xd7deliverycontroller::monitordatabasename,
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      require                  => [
        Dsc_xd7database['XD7SiteDatabase'],
        Dsc_xd7database['XD7SiteMonitorDatabase'],
        Dsc_xd7database['XD7SiteLoggingDatabase'] ]
    }

    #Linking with Citrix License server
    dsc_xd7sitelicense{ 'XD7SiteLicense':
      dsc_licenseserver                 => $xd7deliverycontroller::licenceserver,
      dsc_licenseedition                => 'PLT',
      dsc_licensemodel                  => 'UserDevice',
      dsc_trustlicenseservercertificate => false,
      dsc_psdscrunascredential          => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      require                           => Dsc_xd7site['XD7Site']
    }

    #Site admin roles for users
    #Administrator has to be created before beeing affected a role
    dsc_xd7administrator{ 'CitrixAdmin':
      dsc_name                 => $xd7deliverycontroller::xd7administrator,
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      require                  => Dsc_xd7site['XD7Site']
    }

    dsc_xd7role{ 'CitrixAdminFullAdministratorRole':
      dsc_name                 => 'Full Administrator',
      dsc_members              => $xd7deliverycontroller::xd7administrator,
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      require                  => [ Dsc_xd7site['XD7Site'] , Dsc_xd7administrator['CitrixAdmin'] ]
    }

    #Site admin roles for Puppet service account
    #Administrator has to be created before beeing affected a role
    dsc_xd7administrator{ 'PuppetServiceAccountCitrixAdmin':
      dsc_name                 => $xd7deliverycontroller::setup_svc_username,
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      require                  => Dsc_xd7site['XD7Site']
    }

    dsc_xd7role{ 'PuppetServiceAccountFullAdministratorRole':
      dsc_name                 => 'Full Administrator',
      dsc_members              => $xd7deliverycontroller::setup_svc_username,
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      require                  => [ Dsc_xd7site['XD7Site'] , Dsc_xd7administrator['PuppetServiceAccountCitrixAdmin'] ]
    }

    #Trust requests sent to XML service
    dsc_xd7siteconfig{'XD7GlobalSiteSetting':
      dsc_issingleinstance                     => 'Yes',
      dsc_trustrequestssenttothexmlserviceport => true,
      dsc_psdscrunascredential                 => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      require                                  => Dsc_xd7site['XD7Site']
    }
  }

  else {
    dsc_xd7waitforsite{ 'WaitForXD7Site':
      dsc_sitename               => $xd7deliverycontroller::sitename,
      dsc_existingcontrollername => $xd7deliverycontroller::site_mastercontroller,
      dsc_credential             => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
      }
    }

  ->dsc_xd7controller{ 'XD7ControllerJoin':
      dsc_sitename               => $xd7deliverycontroller::sitename,
      dsc_existingcontrollername => $xd7deliverycontroller::site_primarycontroller,
      dsc_credential             => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
      }
    }
  }

}
