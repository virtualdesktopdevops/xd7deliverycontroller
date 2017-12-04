class xd7mastercontroller::sslconfig inherits xd7mastercontroller {
  if $https {
    #Donwload and import SSL certificate in WebHosting store
    dsc_file{ 'SSLCert':
      dsc_sourcepath => $sslCertificateSourcePath,
      dsc_destinationpath => 'c:\SSL\cert.pfx',
      dsc_type => 'File'
    }
    
    dsc_xpfximport{ 'ImportSSLCert':
      dsc_thumbprint => $sslCertificateThumbprint,
      dsc_path => 'c:\SSL\cert.pfx',
      dsc_location => 'LocalMachine',
      dsc_store => 'WebHosting',
      dsc_credential => {'user' => 'cert', 'password' => $sslCertificatePassword },
      require => Dsc_file['SSLCert']
    }
    
    #Configure IIS HTTPS binding (remove HTTP binding)
    dsc_xwebsite{ 'DefaultWebSite': 
      dsc_name => 'Default Web Site',
      dsc_physicalpath => 'C:\inetpub\wwwroot',
      dsc_bindinginfo => [
        { protocol => 'HTTPS', port => '443', certificatethumbprint => $sslCertificateThumbprint, certificatestorename => 'WebHosting' },
        #{ protocol => 'HTTPS', certificatethumbprint => 'A4D8B8E3B1B6910CB54C3B6CDFD6478914327850' },
        #{ protocol => 'HTTPS', certificatestorename => 'My'; },
        #{ protocol => 'HTTP', port => '80'}
        ],
      require => Dsc_xpfximport['ImportSSLCert']
    }
    
    #Configure SSL offloading on IIS Default web site and forward the request to Citrix XML services listening on port 80
    file{'c:/inetpub/wwwroot/web.config':
      ensure  => file,
      content => template('xd7mastercontroller/web.config.erb')  
    }
    
		#Configure Citrix XML Service SSL port
		registry_value { 'HKLM\SOFTWARE\Citrix\DesktopServer\XmlServicesSslPort':
		  ensure => present,
		  type   => 'dword',
		  data   => '443',
		  require => Dsc_xd7features ['XD7DeliveryController']
		}
  }
}
