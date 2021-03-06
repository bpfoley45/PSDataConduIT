<#
    .SYNOPSIS
    Sends an event to DataConduIT.

    .DESCRIPTION   
    Sends an event to DataConduIT. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Send-Event
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Send-Event
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost.')]
        [string]$Server = $Script:Server,
        
        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The source parameter.')]
        [string]$Source = $Script:EventSource,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The device parameter.')]
        [string]$Device = [String]::Empty,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The sub device parameter.')]
        [string]$SubDevice = [String]::Empty,

        [Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The message parameter.')]
        [string]$Message = [String]::Empty,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The badge id parameter.')]
        [long]$BadgeID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Indicates if this is an access granted event.')]
        [bool]$IsAccessGrant = $false,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Indicates if this is an access denied event.')]
        [bool]$IsAccessDeny = $false,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The time parameter.')]
        [DateTime]$Time = [DateTime]::UtcNow
    )

    process {
        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Class="Lnl_IncomingEvent";
            Name="SendIncomingEvent";
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Invoke-WmiMethod @parameters -ArgumentList $BadgeID, $Message, $Device, $null, $IsAccessGrant, $IsAccessDeny, $Source, $SubDevice, (ToWmiDateTime $Time)
    }
}