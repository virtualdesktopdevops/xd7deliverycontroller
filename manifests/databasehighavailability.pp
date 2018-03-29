#Class configuring SQL Server AlwaysOn High-Availability feature for Citrix databases
class xd7deliverycontroller::databasehighavailability inherits xd7deliverycontroller {

  if ($xd7deliverycontroller::role == 'primary') and ($xd7deliverycontroller::sqlalwayson) {
    #Recovery mode configuration
    dsc_sqldatabaserecoverymodel{'SiteDatabaseRecoveryModel':
      dsc_name                 => $xd7deliverycontroller::sitedatabasename,
      dsc_recoverymodel        => 'Full',
      dsc_servername           => $xd7deliverycontroller::databaseserver,
      dsc_instancename         => 'MSSQLSERVER',
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      require                  => Dsc_xd7site['XD7Site']
    }

    dsc_sqldatabaserecoverymodel{'LoggingDatabaseRecoveryModel':
      dsc_name                 => $xd7deliverycontroller::loggingdatabasename,
      dsc_recoverymodel        => 'Full',
      dsc_servername           => $xd7deliverycontroller::databaseserver,
      dsc_instancename         => 'MSSQLSERVER',
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      require                  => Dsc_xd7site['XD7Site']
    }

    dsc_sqldatabaserecoverymodel{'MonitorDatabaseRecoveryModel':
      dsc_name                 => $xd7deliverycontroller::monitordatabasename,
      dsc_recoverymodel        => 'Full',
      dsc_servername           => $xd7deliverycontroller::databaseserver,
      dsc_instancename         => 'MSSQLSERVER',
      dsc_psdscrunascredential => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      require                  => Dsc_xd7site['XD7Site']
    }

    #AlwaysOn cluster databases membership activation
    dsc_sqlagdatabase{'SiteDatabaseAlwaysOn':
      dsc_databasename          => $xd7deliverycontroller::sitedatabasename,
      dsc_availabilitygroupname => $xd7deliverycontroller::sqlavailabilitygroup,
      dsc_servername            => $xd7deliverycontroller::databaseserver,
      dsc_instancename          => 'MSSQLSERVER',
      dsc_backuppath            => $xd7deliverycontroller::sqldbbackuppath,
      dsc_psdscrunascredential  => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      #require                  => Dsc_sqldatabaserecoverymodel['SiteDatabaseRecoveryModel']
    }

    dsc_sqlagdatabase{'LoggingDatabaseAlwaysOn':
      dsc_databasename          => $xd7deliverycontroller::loggingdatabasename,
      dsc_availabilitygroupname => $xd7deliverycontroller::sqlavailabilitygroup,
      dsc_servername            => $xd7deliverycontroller::databaseserver,
      dsc_instancename          => 'MSSQLSERVER',
      dsc_backuppath            => $xd7deliverycontroller::sqldbbackuppath,
      dsc_psdscrunascredential  => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      #require                  => Dsc_sqldatabaserecoverymodel['LoggingDatabaseRecoveryModel']
    }

    dsc_sqlagdatabase{'MonitorDatabaseAlwaysOn':
      dsc_databasename          => $xd7deliverycontroller::monitordatabasename,
      dsc_availabilitygroupname => $xd7deliverycontroller::sqlavailabilitygroup,
      dsc_servername            => $xd7deliverycontroller::databaseserver,
      dsc_instancename          => 'MSSQLSERVER',
      dsc_backuppath            => $xd7deliverycontroller::sqldbbackuppath,
      dsc_psdscrunascredential  => {
        'user'     => $xd7deliverycontroller::setup_svc_username,
        'password' => $xd7deliverycontroller::setup_svc_password
        },
      #require                  => Dsc_sqldatabaserecoverymodel['MonitorDatabaseRecoveryModel']
    }
  }
}
