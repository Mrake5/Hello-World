function New-AdvancedFunction {
    <#
    .SYNOPSIS
    .EXAMPLE
        PS> New-AdvancedFunction -Param1 MYPARAM

        This example does something to this and that.
    .PARAMETER Param 1
        This param does this thing.
    .PARAMETER
    .PARAMETER    
    #>
    [CmdletBinding()]
    param (
        [string]$Param1
    )
    process {
        try {
            
        }
## Good Default Practice to simplify error displays
        catch {
            Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
        }
    }
}