<#
    .SYNOPSIS
    Sets the context server and credentials used to connect to DataConduIT.

    .DESCRIPTION   
    Sets the context server and credentials used to connect to DataConduIT. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Set-Context -Server localhost
    
    .EXAMPLE
    Set-Context -Server SERVER -Credentials (Get-Credential)

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Set-Context
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost.')]
        [string]$Server,

        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]$Credential,

        [Parameter(
            Position=2,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The default event source used to send events to DataConduIT.')]
        [string]$EventSource = [String]::Empty
    )

    process {
        if($Server.ToLowerInvariant() -eq 'localhost') {
            $Server = '.'
        }

        Set-Variable -Name Server -Value $Server -Scope Script
        Write-Verbose -Message ("Changed context server to '$($Server)'")

        Set-Variable -Name Credential -Value $Credential -Scope Script
        Write-Verbose -Message ("Changed context credential to '$($Credential.UserName)'")

        Set-Variable -Name EventSource -Value $EventSource -Scope Script
        Write-Verbose -Message ("Changed context event source to '$($EventSource)'")
    }
}