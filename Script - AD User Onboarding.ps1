# edit function pause to display closing of script instead of default
function pause{ $null = Read-Host 'Press Enter to close...' }
Write-host "

-----------------------------------
    New User Creation Script
-----------------------------------" -ForegroundColor Yellow

# Create copy user variable using sam account
# This loop will ensure the user you copy exists before passing through to the next stage
do {
    $copyV = Read-Host "Enter a current user's account name that you want to copy from (first inital + last name)"
    $existsV = Get-AdUser -Filter {SamAccountName -eq $copyV}
    if ($null -eq $existsV) {
        Write-host "

 $copyV does not exist. Try again...
       
       " -ForegroundColor Red
    }
    }
while ($null -eq $existsV)

# Create OU path variable using: Copy variable using Distingiushed Name and splitting it in 2 from the first @ symbol
# Create email domain variable using: Copy variable (without @) and splitting in 2 from the first @ symbol

$pathV = (get-aduser -identity $copyV -properties DistinguishedName | select-object -ExpandProperty DistinguishedName).split(',',2)[1]
$domainV = ((get-aduser $copyV).UserPrincipalName).split('@',2)[1] # short form of whats above
$copyFullV = ((get-aduser $copyV).name).ToUpper()


Write-host "
 $copyFullV's groups and OU path in Active Directory will now be used when creating the new user.
 " -ForegroundColor Yellow

# Create new user variable, Enter first name & then last name
# create an inital out of the first name
# create a variable for the sam name combining inital and last name
# store password in hash
# store NetBios name of the domain

$GivenNameV = (Read-Host "Enter the new user's first name")
$SurNameV = Read-Host "Enter the new user's Last name"
$initialV = $GivenNameV[0]
$samV = ("$initialV$SurNameV").ToLower()
$passwordV = Read-Host 'What is the password?' -AsSecureString
$NetBiosV = get-addomain | select-object -ExpandProperty netbiosname

# Using nested loops. Now it will create the user using the variables entered
# try will flow if no errors. If if the user does/doesn't exist n the AD
# else will flow if there is errors and will output the errors

try {
    if ($null -eq (Get-ADUser -Filter {SamAccountName -eq $samV}))  {

        New-ADUser -name "$GivenNameV $SurNameV" -DisplayName "$GivenNameV $SurNameV" -GivenName "$GivenNameV" -Surname "$SurNameV" -SamAccountName "$samV" `
        -UserPrincipalName "$samV@$domainV" -Path $pathV `
        -AccountPassword $passwordV -enable $true `
        -OtherAttributes @{"mail" = "$samV@$domainV"}

        # Now it will add group member from copied user to the new user
        Get-ADUser -identity $copyV -properties memberof | select-object -ExpandProperty memberof | Add-ADGroupMember -members "$samV"
        $GroupV = (Get-ADPrincipalGroupMembership $samV | select-object -ExpandProperty name) -Join ","

        # output the results
        Write-host "

-----------------------------------
          User Created!
-----------------------------------" -ForegroundColor Yellow
    Write-host "
 Display Name: $GivenNameV $SurNameV
 Username: $NetBiosV\$samV
 Email Address: $samV@$domainV
 Groups Membership: $GroupV

" -ForegroundColor Green
        }
    elseif ($null -ne (Get-ADUser -Filter {SamAccountName -eq $samV}))  {
    Write-host "

-----------------------------------
        User already exists!
-----------------------------------" -ForegroundColor Yellow
    Write-Host "
 $GivenNameV $SurNameV already exists in Active Directory as the following..
 Username: $NetBiosV\$samV
 Email Address: $samV@$domainV

" -ForegroundColor Yellow
}

}
catch {
    Write-host "
----------------------------------
            Errors!
-----------------------------------" -ForegroundColor Red
    Write-Host " 
 $_ 

 No user created. Run the script again
    " -ForegroundColor Yellow
    
    if ($null -ne (Get-ADUser -Filter {SamAccountName -eq $samV})){
        remove-aduser $samV -Confirm:$false
    }

}

pause