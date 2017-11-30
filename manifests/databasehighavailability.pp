class xd7mastercontroller::databasehighavailability inherits xd7mastercontroller {
  
	if $sqlalwayson {
		#Recovery mode configuration
		dsc_xsqlserverdatabaserecoverymodel{'SiteDatabaseRecoveryModel':
			dsc_name => $sitedatabasename,
			dsc_recoverymodel => 'Full',
			dsc_sqlserver => $databaseserver,
			dsc_sqlinstancename => 'MSSQLSERVER',
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			require => Dsc_xd7site['XD7Site']
		}
		
		dsc_xsqlserverdatabaserecoverymodel{'LoggingDatabaseRecoveryModel':
			dsc_name => $loggingdatabasename,
			dsc_recoverymodel => 'Full',
			dsc_sqlserver => $databaseserver,
			dsc_sqlinstancename => 'MSSQLSERVER',
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			require => Dsc_xd7site['XD7Site']
		}
		
		dsc_xsqlserverdatabaserecoverymodel{'MonitorDatabaseRecoveryModel':
			dsc_name => $monitordatabasename,
			dsc_recoverymodel => 'Full',
			dsc_sqlserver => $databaseserver,
			dsc_sqlinstancename => 'MSSQLSERVER',
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			require => Dsc_xd7site['XD7Site']
		} 
		
		#AlwaysOn cluster databases membership activation
		dsc_xsqlserveralwaysonavailabilitygroupdatabasemembership{'SiteDatabaseAlwaysOn':
			dsc_databasename => $sitedatabasename,
			dsc_availabilitygroupname => $sqlavailabilitygroup,
			dsc_sqlserver => $databaseserver,
			dsc_sqlinstancename => 'MSSQLSERVER',
			dsc_backuppath => $sqldbbackuppath,
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			#require => Dsc_xsqlserverdatabaserecoverymodel['SiteDatabaseRecoveryModel']
		}
		
		dsc_xsqlserveralwaysonavailabilitygroupdatabasemembership{'LoggingDatabaseAlwaysOn':
			dsc_databasename => $loggingdatabasename,
			dsc_availabilitygroupname => $sqlavailabilitygroup,
			dsc_sqlserver => $databaseserver,
			dsc_sqlinstancename => 'MSSQLSERVER',
			dsc_backuppath => $sqldbbackuppath,
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			#require => Dsc_xsqlserverdatabaserecoverymodel['LoggingDatabaseRecoveryModel']
		}
		
    dsc_xsqlserveralwaysonavailabilitygroupdatabasemembership{'MonitorDatabaseAlwaysOn':
			dsc_databasename => $monitordatabasename,
			dsc_availabilitygroupname => $sqlavailabilitygroup,
			dsc_sqlserver => $databaseserver,
			dsc_sqlinstancename => 'MSSQLSERVER',
			dsc_backuppath => $sqldbbackuppath,
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			#require => Dsc_xsqlserverdatabaserecoverymodel['MonitorDatabaseRecoveryModel']
		}
	  
	}  
  
}
