param([string]$userName,[hashtable]$Attributes)


try {
## Attempt to find the username
$userAccount = Get-ADUser -Identity $userName
if (!$userAccount) {
    Write-Warning "The username '$username' does not exist"
    return
}
} Catch {
    
}

## The $Attributes parameter will contain only the parameters for the Set-AdUser cmdlet other than Password. If this is in $Attributes it needs to be treated differently.
if ($Attributes.ContainsKey('Password')) {
    $userAccount | Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Attributes.Password -Force)
## Remove the password key because we'll be passing this hashtable directly to Set-AdUser later.
    $Attributes.Remove('Password')
}

$userAccount | Set-ADUser @Attributes
