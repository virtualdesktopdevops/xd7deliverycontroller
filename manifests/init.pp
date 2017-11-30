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
	$svc_username,
	$svc_password,
	$sitename,
	$databaseserver,
	$licenceserver,
	$sitedatabasename='CitrixSiteDB',
	$loggingdatabasename='CitrixLogDB',
	$monitordatabasename='CitrixMonitorDB',
	$sourcepath,
	$xd7administrator,
	$domainNetbiosName,
	$sqlalwayson = false,
	$sqlavailabilitygroup = '', #Name of the SQL Server Availability group
	$sqldbbackuppath = '',
	$https = false,
	$sslCertificateSourcePath = '',
	$sslCertificatePassword = '',
	$sslCertificateThumbprint = ''
)

{
	contain xd7mastercontroller::install
	contain xd7mastercontroller::siteconfig
	contain xd7mastercontroller::databasehighavailability
	contain xd7mastercontroller::sslconfig
	Class['::xd7mastercontroller::install'] ->
	Class['::xd7mastercontroller::siteconfig'] ->
	#Class['::xd7mastercontroller::databasehighavailability'] ->
	Class['::xd7mastercontroller::sslconfig']
	
	reboot { 'dsc_reboot':
	 when    => pending
	}
}

