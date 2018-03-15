#Class configuring SQL Server AlwaysOn High-Availability feature for Citrix databases
class xd7mastercontroller::databasehighavailability inherits xd7mastercontroller {

  if ($xd7mastercontroller::role == 'primary') and ($xd7mastercontroller::sqlalwayson) {
    #Recovery mode configuration
    dsc_sqldatabaserecoverymodel{'SiteDatabaseRecoveryModel':
      dsc_name                 => $xd7mastercontroller::sitedatabasename,
      dsc_recoverymodel        => 'Full',
      dsc_servername           => $xd7mastercontroller::databaseserver,
      dsc_instancename         => 'MSSQLSERVER',
      dsc_psdscrunascredential => {
        'user'     => $xd7mastercontroller::setup_svc_username,
        'password' => $xd7mastercontroller::setup_svc_password
        },
      require                  => Dsc_xd7site['XD7Site']
    }

    dsc_sqldatabaserecoverymodel{'LoggingDatabaseRecoveryModel':
      dsc_name                 => $xd7mastercontroller::loggingdatabasename,
      dsc_recoverymodel        => 'Full',
      dsc_servername           => $xd7mastercontroller::databaseserver,
      dsc_instancename         => 'MSSQLSERVER',
      dsc_psdscrunascredential => {
        'user'     => $xd7mastercontroller::setup_svc_username,
        'password' => $xd7mastercontroller::setup_svc_password
        },
      require                  => Dsc_xd7site['XD7Site']
    }

    dsc_sqldatabaserecoverymodel{'MonitorDatabaseRecoveryModel':
      dsc_name                 => $xd7mastercontroller::monitordatabasename,
      dsc_recoverymodel        => 'Full',
      dsc_servername           => $xd7mastercontroller::databaseserver,
      dsc_instancename         => 'MSSQLSERVER',
      dsc_psdscrunascredential => {
        'user'     => $xd7mastercontroller::setup_svc_username,
        'password' => $xd7mastercontroller::setup_svc_password
        },
      require                  => Dsc_xd7site['XD7Site']
    }

    #AlwaysOn cluster databases membership activation
    dsc_sqlagdatabase{'SiteDatabaseAlwaysOn':
      dsc_databasename          => $xd7mastercontroller::sitedatabasename,
      dsc_availabilitygroupname => $xd7mastercontroller::sqlavailabilitygroup,
      dsc_servername            => $xd7mastercontroller::databaseserver,
      dsc_instancename          => 'MSSQLSERVER',
      dsc_backuppath            => $xd7mastercontroller::sqldbbackuppath,
      dsc_psdscrunascredential  => {
        'user'     => $xd7mastercontroller::setup_svc_username,
        'password' => $xd7mastercontroller::setup_svc_password
        },
      #require                  => Dsc_sqldatabaserecoverymodel['SiteDatabaseRecoveryModel']
    }

    dsc_sqlagdatabase{'LoggingDatabaseAlwaysOn':
      dsc_databasename          => $xd7mastercontroller::loggingdatabasename,
      dsc_availabilitygroupname => $xd7mastercontroller::sqlavailabilitygroup,
      dsc_servername            => $xd7mastercontroller::databaseserver,
      dsc_instancename          => 'MSSQLSERVER',
      dsc_backuppath            => $xd7mastercontroller::sqldbbackuppath,
      dsc_psdscrunascredential  => {
        'user'     => $xd7mastercontroller::setup_svc_username,
        'password' => $xd7mastercontroller::setup_svc_password
        },
      #require                  => Dsc_sqldatabaserecoverymodel['LoggingDatabaseRecoveryModel']
    }

    dsc_sqlagdatabase{'MonitorDatabaseAlwaysOn':
      dsc_databasename          => $xd7mastercontroller::monitordatabasename,
      dsc_availabilitygroupname => $xd7mastercontroller::sqlavailabilitygroup,
      dsc_servername            => $xd7mastercontroller::databaseserver,
      dsc_instancename          => 'MSSQLSERVER',
      dsc_backuppath            => $xd7mastercontroller::sqldbbackuppath,
      dsc_psdscrunascredential  => {
        'user'     => $xd7mastercontroller::setup_svc_username,
        'password' => $xd7mastercontroller::setup_svc_password
        },
      #require                  => Dsc_sqldatabaserecoverymodel['MonitorDatabaseRecoveryModel']
    }
  }
}
