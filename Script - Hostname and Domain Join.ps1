# The following script will change the hostname and add the device to the domain (fictious organization named corpo.com)
    # For the hostname it will prompt whether the device is a laptop or desktop (LT/DT). 
        # It will also extract serial number for the suffix part of the hostname
    # For the domain, it will prompt for the username and password. Storing it in hash for later.
        # Depending on device type, it will move the device to the correct OU in active directory

    Write-Host "Please enter username & Password for domain admin(this will be used to join the domain)" -ForegroundColor Yellow
    $DomainCred = Get-Credential

    $SerialN = Get-CimInstance Win32_BIOS | select-object -ExpandProperty serialNumber

    $DeviceT = Read-Host "Enter device type DT or LT:"
    if ($DeviceT -eq "LT" -or $DeviceT -eq "DT") {
        $NewName = "CORPO-$DeviceT-$SerialN"
        if ($DeviceT -eq "LT") {
            $OUpathway = "OU=Laptops,OU=WorkStations,OU=CORPO,DC=corpo,DC=com"
        }
        if ($DeviceT -eq "DT") {
            $OUpathway = "OU=Desktops,OU=WorkStations,OU=CORPO,DC=corpo,DC=com"
        }
        Add-Computer -NewName $NewName -DomainName corpo -Credential $DomainCred -OUPath $OUpathway -
        Write-Host "Hostname was successfully changed to: $NewName. REBOOT for changes to take effect" -ForegroundColor Green        
    }
    else {
        Read-Host "Incorrect Format of device type, You must enter DT for desktop or LT for laptop. Press Enter to exit"
    }