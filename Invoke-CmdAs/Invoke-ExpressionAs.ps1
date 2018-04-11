# Requires Jetbean.runas.exe to be copies to remote machine.
# For now it's downloading the CmdAs.exe from the GitHub repo

function Invoke-ExpressionAs {

    [cmdletbinding()]
    Param(
    [Parameter(Mandatory = $true)][System.Management.Automation.PSCredential]$Credential,
    [Parameter(Mandatory = $true)][String]$Command
    )

    $CmdAs = "${Env:Temp}\CmdAs.exe"
    If (!(Test-Path -Path $CmdAs)) { 
        (new-object Net.WebClient).DownloadFile('https://github.carboniteinc.com/mkellerman/PSRunAs/blob/master/Invoke-CmdAs/CmdAs_x64.exe?raw=true', $CmdAs)
    }

    $CmdCredential = @{}
    If ($Credential) {
        $CmdCredential['u'] = $($Credential).GetNetworkCredential().Username
        $CmdCredential['p'] = $($Credential).GetNetworkCredential().Password
    }
    $EncodedCommand = [Convert]::ToBase64String(([System.Text.Encoding]::Unicode.GetBytes(([ScriptBlock]::Create($Command)))))
    & $CmdAs @CmdCredential powershell.exe -NoLogo -ExecutionPolicy Bypass -NonInteractive -NoProfile -OutputFormat XML -EncodedCommand $EncodedCommand

}