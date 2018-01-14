class xd7mastercontroller::sslconfig inherits xd7mastercontroller {
  if $https {
    reboot { 'after_sslconfig':
      apply => finished,
      when => refreshed
    }

    #Download SSL certificate
    dsc_file{ 'SSLCert':
      dsc_sourcepath => "\\${sslCertificateSourcePath}",
      dsc_destinationpath => 'c:\SSL\cert.pfx',
      dsc_type => 'File'
    }->

    #Load SSL certificate in Local Computer personal certificate store
    dsc_xpfximport{ 'ImportSSLCert':
      dsc_thumbprint => $sslCertificateThumbprint,
      dsc_path => 'c:\SSL\cert.pfx',
      dsc_location => 'LocalMachine',
      dsc_store => 'My',
      dsc_credential => {'user' => 'cert', 'password' => $sslCertificatePassword },
      require => Dsc_file['SSLCert']
    }->

    #Map SSL certificate to Citrix Broker Service using netsh method
    #netsh http add sslcert ipport=0.0.0.0:443 certhash=<Certificate Hash Number> appid={<Citrix Broker Service GUID>}
    dsc_script{ 'CitrixBrokerServiceSSL':
      dsc_getscript => 'Return @{ Result = [string]$(netsh http show sslcert) }',
      dsc_testscript => 'If ((netsh http show sslcert | Select-String  "Application ID") -like "*Application*") {
              Return $true
            } Else {
               Return $false
            }',
      dsc_setscript => "\$brokerservice = get-wmiobject -class Win32_Product | Where-Object {\$_.name -Like \"*Broker Service*\"}
          \$guid = \$brokerservice.IdentifyingNumber
          netsh http add sslcert ipport=0.0.0.0:443 certhash=${$sslCertificateThumbprint} appid=\$guid",
      notify => Reboot['after_sslconfig']
    }

    #Make sure Citrix XML Service SSL port is 443
    registry_value { 'HKLM\SOFTWARE\Citrix\DesktopServer\XmlServicesSslPort':
      ensure => present,
      type   => 'dword',
      data   => '443',
      require => Dsc_xd7features['XD7DeliveryController']
    }
  }
}
