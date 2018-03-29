# Class: xd7deliverycontroller
#
# This module manages xd7deliverycontroller
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class xd7deliverycontroller (
  String $setup_svc_username,
  String $setup_svc_password,
  String $sourcepath,
  String $sitename,
  Enum['primary', 'secondary'] $role,
  Optional[String] $databaseserver                   = '',
  Optional[String] $licenceserver                    = '',
  Optional[String] $xd7administrator                 = '',
  Optional[String] $site_primarycontroller           = '',
  Optional[String] $sitedatabasename                 = 'CitrixSiteDB',
  Optional[String] $loggingdatabasename              = 'CitrixLogDB',
  Optional[String] $monitordatabasename              = 'CitrixMonitorDB',
  Optional[Boolean] $sqlalwayson                     = false,
  Optional[String] $sqlavailabilitygroup             = '',
  Optional[String] $sqldbbackuppath                  = '',
  Enum['internet', 'offline'] $sqlservermodulesource = 'internet',
  Optional[String] $sqlservermodulesourcepath        = '',
  Optional[Boolean] $https                           = false,
  Optional[String] $sslcertificatesourcepath         = '',
  Optional[String] $sslcertificatepassword           = '',
  Optional[String] $sslcertificatethumbprint         = ''
)

{
  contain xd7deliverycontroller::install
  contain xd7deliverycontroller::siteconfig
  contain xd7deliverycontroller::databasehighavailability
  contain xd7deliverycontroller::sslconfig

  Class['::xd7deliverycontroller::install']
  ->Class['::xd7deliverycontroller::siteconfig']
  #->Class['::xd7deliverycontroller::databasehighavailability']
  ->Class['::xd7deliverycontroller::sslconfig']

  reboot { 'dsc_reboot':
    when    => pending
  }
}
