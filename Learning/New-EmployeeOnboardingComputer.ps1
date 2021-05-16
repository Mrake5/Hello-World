param($computerName,$Location = 'OU=Corporate Computers')
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