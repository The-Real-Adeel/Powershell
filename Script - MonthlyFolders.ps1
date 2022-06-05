#Set Folder Path
$Path = 'C:\users\MyPc\Desktop\TestFolder'

#Set Year. If entered incorrectly, Try again

do {
    try {[ValidatePattern ('[0-9][0-9][0-9][0-9]')]$year = Read-Host "Enter Year"}
    catch {Write-Host "Invalid format. Please try again by entering 4 digits." -ForegroundColor Blue}
   } until ($year)   

# Create a Loop which increments by 1 (1-12). It stops as soon as it hits 13.
# Store month in long format i.e March instead of the integer 3
# Create a directory variable that is "Path\Year\Incrementing integer <space> Month"

for ($i = 1; $i -lt 13; $i++) {

    $Month = Get-Date -month $i -UFormat "%B"

     $Dir = "{0}\{1}\$i {2}" -f (

     $Path,
     $year,
     $month

    )
# for each increment until it hits 13.. create the folder in the directory path  
    New-Item -path $dir -ItemType Directory

 }