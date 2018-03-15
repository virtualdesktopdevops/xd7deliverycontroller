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
  String $setup_svc_username,
  String $setup_svc_password,
  String $sitename,
  Enum['primary', 'secondary'] $role,
  String $databaseserver,
  String $licenceserver,
  String $sourcepath,
  String $xd7administrator,
  Optional[String] $site_primarycontroller           = '',
  Optional[String] $sitedatabasename                 = 'CitrixSiteDB',
  Optional[String] $loggingdatabasename              = 'CitrixLogDB',
  Optional[String] $monitordatabasename              = 'CitrixMonitorDB',
  Boolean $sqlalwayson                               = false,
  Optional[String] $sqlavailabilitygroup             = '',
  Optional[String] $sqldbbackuppath                  = '',
  Enum['internet', 'offline'] $sqlservermodulesource = 'internet',
  Optional[String] $sqlservermodulesourcepath        = '',
  Boolean $https                                     = false,
  Optional[String] $sslcertificatesourcepath         = '',
  Optional[String] $sslcertificatepassword           = '',
  Optional[String] $sslcertificatethumbprint         = ''
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
