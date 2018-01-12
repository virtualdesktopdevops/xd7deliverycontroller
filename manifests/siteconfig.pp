class xd7mastercontroller::siteconfig inherits xd7mastercontroller {

	#Databases creation
	dsc_xd7database{ 'XD7SiteDatabase':
	 dsc_sitename => $sitename,
	 dsc_databaseserver => $databaseserver,
	 dsc_databasename => $sitedatabasename,
	 dsc_datastore => 'Site',
	 dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
	 #require => Dsc_xd7features['XD7DeliveryController']
	}

	dsc_xd7database{ 'XD7SiteLoggingDatabase':
	 dsc_sitename => $sitename,
	 dsc_databaseserver => $databaseserver,
	 dsc_databasename => $loggingdatabasename,
	 dsc_datastore => 'Logging',
	 dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
	 #require => Dsc_xd7features['XD7DeliveryController']
	}

	dsc_xd7database{ 'XD7SiteMonitorDatabase':
	 dsc_sitename => $sitename,
	 dsc_databaseserver => $databaseserver,
	 dsc_databasename => $monitordatabasename,
	 dsc_datastore => 'Monitor',
	 dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
	 #require => Dsc_xd7features['XD7DeliveryController']
	}

	#XD7 site creation
	dsc_xd7site{ 'XD7Site':
	 dsc_sitename => $sitename,
	 dsc_databaseserver => $databaseserver,
	 dsc_sitedatabasename => $sitedatabasename,
	 dsc_loggingdatabasename => $loggingdatabasename,
	 dsc_monitordatabasename => $monitordatabasename,
	 dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
	 require => [Dsc_xd7database['XD7SiteDatabase'], Dsc_xd7database['XD7SiteMonitorDatabase'], Dsc_xd7database['XD7SiteLoggingDatabase'] ]
	}

	#Linking with Citrix License server
	dsc_xd7sitelicense{ 'XD7SiteLicense':
	 dsc_licenseserver => $licenceserver,
	 dsc_licenseedition => 'PLT',
	 dsc_licensemodel => 'UserDevice',
	 dsc_trustlicenseservercertificate => false,
	 dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
	 require => Dsc_xd7site['XD7Site']
	}

  #Site admin roles for users
  #Administrator has to be created before beeing affected a role
	dsc_xd7administrator{ 'CitrixAdmin':
	 dsc_name => $xd7administrator,
	 dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
	 require => Dsc_xd7site['XD7Site']
	}

	dsc_xd7role{ 'CitrixAdminFullAdministratorRole':
	 dsc_name => 'Full Administrator',
	 dsc_members => $xd7administrator,
	 dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
	 require => [ Dsc_xd7site['XD7Site'] , Dsc_xd7administrator['CitrixAdmin'] ]
  }

	#Site admin roles for Puppet service account
	#Administrator has to be created before beeing affected a role
	dsc_xd7administrator{ 'PuppetServiceAccountCitrixAdmin':
	 dsc_name => $svc_username,
	 dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
	 require => Dsc_xd7site['XD7Site']
	}

	dsc_xd7role{ 'PuppetServiceAccountFullAdministratorRole':
	 dsc_name => 'Full Administrator',
	 dsc_members => $svc_username,
	 dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
	 require => [ Dsc_xd7site['XD7Site'] , Dsc_xd7administrator['PuppetServiceAccountCitrixAdmin'] ]
  }

	#Trust requests sent to XML service
	dsc_xd7siteconfig{'XD7GlobalSiteSetting':
	 dsc_issingleinstance => 'Yes',
	 dsc_trustrequestssenttothexmlserviceport => true,
	 dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
	 require => Dsc_xd7site['XD7Site']
	}
}
