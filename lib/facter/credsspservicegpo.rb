#https://puppet.com/blog/starting-out-writing-custom-facts-windows
Facter.add('credsspservicegpo') do
  confine :osfamily => :windows
  setcode do
    begin
      result=false
      value = nil
      Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Policies\Microsoft\Windows\WinRM\Service') do |regkey|
        value = regkey['AllowCredSSP']
        result=true
      end
      result
    rescue
      false
    end
  end
end
