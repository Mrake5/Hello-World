function New-EmployeeOnboardUser {
    <#
    .SYNOPSIS
        This function is part of the Active Directory Account Managerment Automator tool. It is used to perform all routing
        tasks that must be done when onboarding a new employee user account.
    .EXAMPLE
        PS> New-EmployeeOnboardUser -FirstName Adam -MiddleInitial N -LastName Singleton -Title 'Manager'

        This example created an AD username based on company standards into a company standard OU and adds the users into the
        company standard main user group.
    .PARAMETER FirstName
        The first name of the employee.
    .PARAMETER MiddleInitial
        The middle initial of the employee.
    .PARAMETER LastName
        The last name of the employee.
    .PARAMETER Title
        The current job title of the employee.
    #>
    [CmdletBinding()]
    param (
        [string]$FirstName
        [string]$MiddleInitial
        [string]$LastName
        [string]$Location = 'OU = Home Users'
        [string]$Title
    )
    process {
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
    }
}

function New-EmployeeOnboardComputer {
    <#
    .SYNOPSIS
        This function is part of the Active Directory Account Managerment Automator tool. It is used to create computer objects within AD in the default
        company OU. 
    .EXAMPLE
        PS> New-EmployeeOnboardComputer -computerName 'TestBox'

        This example creates a computer object within AD named 'TestBox' and places it within the 'Corporate Computers' OU.
    .PARAMETER computerName
        The name of the computer object.
    .PARAMETER Location
        The OU that the computer object will be placed in.
    #>
    [CmdletBinding()]
    param (
        [string]$computerName
        [string]$Location = 'OU=Corporate Computers'
    )
    process {
        try {
            if (Get-ADComputer $computerName) {
                Write-Warning "The computer name '$computerName' already exists"
                return
            }
            } catch {
            
            }
            
            $domainDN = (Get-ADDomain).distinguishedname
            $defaultOuPath = "$Location,$domainDN"
            
            New-ADComputer -Name $computerName -Path $defaultOuPath
    }
}