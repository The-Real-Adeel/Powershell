Write-host @"

-----------------------------------
    New User Creation Script
-----------------------------------

"@ -ForegroundColor Yellow



# Create copy user variable using sam account
# Create OU path variable using: Copy variable using Distingiushed Name and splitting it in 2 from the first @ symbol
# Create email domain variable using: Copy variable (without @) and splitting in 2 from the first @ symbol

$copyV = Read-Host "Enter a current user's account name that you want to copy from (first inital + last name)"
$pathV = (get-aduser -identity $copyV -properties DistinguishedName | select-object -ExpandProperty DistinguishedName).split(',',2)[1]
$domainV = ((get-aduser $copyV).UserPrincipalName).split('@',2)[1] # short form of whats above
$copyFullV = ((get-aduser $copyV).name).ToUpper()


Write-host @"

 $copyFullV's groups and OU path in Active Directory will now be used when creating the new user.

"@ -ForegroundColor Yellow



# Create new user variable, Enter first name & then last name
# create an inital out of the first name
# create a variable for the sam name combining inital and last name

$GivenNameV = (Read-Host "Enter the new user's first name")
$SurNameV = Read-Host "Enter the new user's Last name"
$initialV = $GivenNameV[0]
$samV = ("$initialV$SurNameV").ToLower()
$passwordV = Read-Host 'What is the password?' -AsSecureString

# Create the user using the variables
New-ADUser -name "$GivenNameV $SurNameV" -DisplayName "$GivenNameV $SurNameV" -GivenName "$GivenNameV" -Surname "$SurNameV" -SamAccountName "$samV" `
-UserPrincipalName "$samV@$domainV" -Path $pathV `
-AccountPassword $passwordV -enable $true `
-OtherAttributes @{"mail" = "$samV@$domainV"}

# Add group member from copied user to new user
Get-ADUser -identity $copyV -properties memberof | select-object -ExpandProperty memberof | Add-ADGroupMember -members "$samV"
$GroupV = (Get-ADPrincipalGroupMembership $samV | select-object -ExpandProperty name) -Join ","
$NetBiosV = get-addomain | select-object -ExpandProperty netbiosname

# output results
Write-host @"

-----------------------------------
           User Created
-----------------------------------
"@ -ForegroundColor Yellow
Write-host @"
Display Name: $GivenNameV $SurNameV
NetBios Name: $NetBiosV\$samV
Email Address: $samV@$domainV
Groups Membership: $GroupV

"@ -ForegroundColor Green

pause