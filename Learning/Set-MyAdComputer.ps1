## Example:
## .\Set-MyAdComputer.ps1 -Computername Windows-VM -Attributes @{'DisplayName' = 'my display name';'Description' = 'my description'}

param([string]$computerName,[hashtable]$Attributes)

## Attempt to find the computer name
try {
    $computer = Get-ADComputer -Identity $computerName
    if (!$computer) {
        Write-Warning "The Computer Name '$computerName' does not exist."
        return        
    }
}
catch {
    
}

## The $Attributes parameter will contain only the parameters for the set-adcomputer cmdlet
$computer | Set-ADComputer @Attributes