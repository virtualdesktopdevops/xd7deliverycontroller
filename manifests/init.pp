# Class: xd7mastercontroller
#
# This module manages xd7mastercontroller
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class xd7mastercontroller (
  $setup_svc_username,
  $setup_svc_password,
  $sitename,
  $databaseserver,
  $licenceserver,
  $sourcepath,
  $xd7administrator,
  $sitedatabasename='CitrixSiteDB',
  $loggingdatabasename='CitrixLogDB',
  $monitordatabasename='CitrixMonitorDB',
  $sqlalwayson = false,
  $sqlavailabilitygroup = '', #Name of the SQL Server Availability group
  $sqldbbackuppath = '',
  $sqlservermodulesource = 'internet',
  $sqlservermodulesourcepath = '',
  $https = false,
  $sslcertificatesourcepath = '',
  $sslcertificatepassword = '',
  $sslcertificatethumbprint = ''
)

{
  contain xd7mastercontroller::install
  contain xd7mastercontroller::siteconfig
  contain xd7mastercontroller::databasehighavailability
  contain xd7mastercontroller::sslconfig
  Class['::xd7mastercontroller::install']
  ->Class['::xd7mastercontroller::siteconfig']
  #->Class['::xd7mastercontroller::databasehighavailability']
  ->Class['::xd7mastercontroller::sslconfig']

  reboot { 'dsc_reboot':
    when    => pending
  }
}
