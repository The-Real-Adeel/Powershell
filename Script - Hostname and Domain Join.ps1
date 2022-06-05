# Replace add-computer line with the following if you dont want to add to domain: Rename-Computer -NewName $NewName
# To Do: Setup a AD Server VM and test joining to domain
# To Do: Set Domain as a variable you enter
# To Do: Add OU paths depending on type: ie. -OUPath "OU=Laptops,OU=Workstations,DC=contoso,DC=local" 

Set-ExecutionPolicy RemoteSigned -Force
# Prompt and store domain credential with password hash to join the domain
    Write-Host "Please Enter username & Password for domain admin(this will be used to join the domain)"
    $DomainCred = Get-Credential
# Extract serialNumber and place it in a variable
    $SerialN = Get-CimInstance Win32_BIOS | select-object -ExpandProperty serialNumber

# Store Device Type in Variable & create hostname and join it to domain: hostname format example: CORP-LT-E4SB3DC
    $DeviceT = Read-Host "Enter device type DT or LT:"
    if ($DeviceT -eq "LT" -or $DeviceT -eq "DT") {
        $NewName = "CORP-$DeviceT-$SerialN"
        Add-Computer -NewName $NewName -DomainName corp.com -Credential $DomainCred
        Read-Host -Prompt "Hostname was successfully changed to: $NewName. Press Enter to Reboot"
        Restart-Computer -Force
    }
    else {
        Read-Host "Incorrect Format of device type, You must enter DT for desktop or LT for laptop. Press Enter to exit"
    }
    Set-ExecutionPolicy Restricted -Force

# Here's what else I would do if this was my script (up to you):
# 1. Use Regex to force input (on the DT or LT portion). You can see how I did that in the script I shared with you. Then you don't need to use a condition / if statement.
# 2. For the reboot prompt - I'd just do a Write-Host instead of Read-Host and just throw in a "pause".
# 3. Add error handling with a try/catch just in case the computer fails to run any of the commands for any reason.
# 4. One more challenge, if you are willing, is to collect credentials and pass them securely as a hash to the script 
