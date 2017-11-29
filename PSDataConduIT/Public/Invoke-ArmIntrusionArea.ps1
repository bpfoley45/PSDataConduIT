<#
    .SYNOPSIS
    Arms the intrusion area.

    .DESCRIPTION   
    Arms the intrusion area.
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Invoke-ArmIntrusionArea
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-ArmIntrusionArea
{
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact="High"
    )]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost')]
        [string]$Server = $Script:Server,
        
        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The intrusion area id parameter')]
        [int]$IntrusionAreaID,

        [Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The intrusion arm method parameter')]
        [ArmState]$Method,

        [switch]$PassThru,

        [switch]$Force
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($intrusionAreas = Get-IntrusionArea @parameters -IntrusionAreaID $IntrusionAreaID) -eq $null) {
            Write-Verbose -Message ("No intrusion areas found")
            return
        }

        foreach($intrusionArea in $intrusionAreas) {
            if($Force -or $PSCmdlet.ShouldProcess("$Server", "Arm intrusion area '$($intrusionArea.Name)' '$($Method)'")) {
                $intrusionArea.Arm.Invoke($Method) | Out-Null
                Write-Verbose -Message ("Intrusion area '$($intrusionArea.Name)' '$($Method)'")
            }

            if($PassThru) {
                Write-Output $$intrusionArea
            }
        }
    }
}