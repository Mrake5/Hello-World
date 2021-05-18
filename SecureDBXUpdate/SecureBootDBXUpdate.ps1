Push-Location $PSScriptRoot

## Import the Presentation Framework related libraries into the current PowerShell session
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::OK

## Details the type of image that will display
$MessageIcon = [System.Windows.MessageBoxImage]::Information
$MessageBody = "Done, please remember to restart your device before re-scanning in Nessus..."
$MessageTitle = Get-Date -DisplayHint Date

if ([System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).bytes) -match 'Microsoft Corporation UEFI CA 2011') {
    Write-Host "Splitting Dbxupdate.bin file into neccesary components..." -ForegroundColor Green
    .\SplitDbxContent.ps1 .\dbxupdate_x64.bin

    Write-Host "Applying the DBX Update..." -ForegroundColor Green
    Set-SecureBootUefi -Name dbx -ContentFilePath .\content.bin -SignedFilePath .\signature.p7 -Time 2010-03-06T19:17:21Z -AppendWrite

    $Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

    Pop-Location
}

else {
    Write-Warning -Message "This package is not applicable to your system."
    Pop-Location
    return
}