class xd7mastercontroller::databasehighavailability inherits xd7mastercontroller {

	if $sqlalwayson {
		#Recovery mode configuration
		dsc_sqldatabaserecoverymodel{'SiteDatabaseRecoveryModel':
			dsc_name => $sitedatabasename,
			dsc_recoverymodel => 'Full',
			dsc_servername => $databaseserver,
			dsc_instancename => 'MSSQLSERVER',
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			require => Dsc_xd7site['XD7Site']
		}

		dsc_sqldatabaserecoverymodel{'LoggingDatabaseRecoveryModel':
			dsc_name => $loggingdatabasename,
			dsc_recoverymodel => 'Full',
			dsc_servername => $databaseserver,
			dsc_instancename => 'MSSQLSERVER',
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			require => Dsc_xd7site['XD7Site']
		}

		dsc_sqldatabaserecoverymodel{'MonitorDatabaseRecoveryModel':
			dsc_name => $monitordatabasename,
			dsc_recoverymodel => 'Full',
			dsc_servername => $databaseserver,
			dsc_instancename => 'MSSQLSERVER',
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			require => Dsc_xd7site['XD7Site']
		}

		#AlwaysOn cluster databases membership activation
		dsc_sqlagdatabase{'SiteDatabaseAlwaysOn':
			dsc_databasename => $sitedatabasename,
			dsc_availabilitygroupname => $sqlavailabilitygroup,
			dsc_servername => $databaseserver,
			dsc_instancename => 'MSSQLSERVER',
			dsc_backuppath => $sqldbbackuppath,
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			#require => Dsc_sqldatabaserecoverymodel['SiteDatabaseRecoveryModel']
		}

		dsc_sqlagdatabase{'LoggingDatabaseAlwaysOn':
			dsc_databasename => $loggingdatabasename,
			dsc_availabilitygroupname => $sqlavailabilitygroup,
			dsc_servername => $databaseserver,
			dsc_instancename => 'MSSQLSERVER',
			dsc_backuppath => $sqldbbackuppath,
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			#require => Dsc_sqldatabaserecoverymodel['LoggingDatabaseRecoveryModel']
		}

		dsc_sqlagdatabase{'MonitorDatabaseAlwaysOn':
			dsc_databasename => $monitordatabasename,
			dsc_availabilitygroupname => $sqlavailabilitygroup,
			dsc_servername => $databaseserver,
			dsc_instancename => 'MSSQLSERVER',
			dsc_backuppath => $sqldbbackuppath,
			dsc_psdscrunascredential => {'user' => $svc_username, 'password' => $svc_password},
			#require => Dsc_sqldatabaserecoverymodel['MonitorDatabaseRecoveryModel']
		}

	}

}
