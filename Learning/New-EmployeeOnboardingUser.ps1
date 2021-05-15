param($FirstName,$MiddleInitial,$LastName,$Location = 'OU=Home Users',$Title)

## Do not store passwords unencrypted in prod environments!!
$DefaultPassword = 'L3arning1sFun'
$DomainDN =(Get-ADDomain).distinguishedname
$DefaultGroup = 'Home Group'


## Figure out what the username should be

$userName = "$($FirstName.substring(0,1))$LastName"
$errorPreferenceBefore = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

## Try/Catch - If an error happens in line 16-21, throw it into a null catch block which will show no red text in the output
try {
if (Get-ADUser $userName) {
    $userName = "$($FirstName.SubString(0,1))$MiddleInitial$LastName"
    if (Get-ADUser $userName) {
        Write-Warning "No acceptable username schema could be created"
        return        
    }
}
} catch {
}

## Create the user account

## Reset the error action preference to default
$ErrorActionPreference = $errorPreferenceBefore

## Splat the new user parameters in a hast table
$NewUserParams = @{
    'UserPrincipalName' = $userName
    'Name' = $userName
    'GivenName' = $FirstName
    'Surname' = $LastName
    'Title' = $Title
    'SamAccountName' = $userName
    'AccountPassword' = (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force)
    'Enabled' = $true
    'Initials' = $MiddleInitial
    'Path' = "$Location,$DomainDN"
    'ChangePasswordAtLogon' = $true
}

New-ADUser @NewUserParams

## Add the user account to the company standard group

Add-ADGroupMember -Identity $DefaultGroup -Members $userName