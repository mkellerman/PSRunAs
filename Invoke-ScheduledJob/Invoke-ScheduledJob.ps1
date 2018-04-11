function Invoke-ScheduledJob {

    [cmdletbinding()]
    Param(
    [Parameter(Mandatory = $true)][ScriptBlock]$ScriptBlock,
    [Parameter(Mandatory = $false)][Object[]]$ArgumentList,
    [Parameter(Mandatory = $false)][PSCredential]$Credential
    )

    Begin {

        $ScheduledJobName = "Invoke-ScheduledJob $([guid]::NewGuid().Guid)"
    
    }
    
    Process {
        
        Try {

            Write-Debug "Registering ScheduledJob"
            $JobParameters = @{ Name = $ScheduledJobName }
            If ($Command)  { $JobParameters['ScriptBlock'] = $ScriptBlock }
            If ($ArgumentList) { $JobParameters['ArgumentList'] = $ArgumentList }
            If ($Credential)   { $JobParameters['Credential'] = $Credential }
            $ScheduledJob = Register-ScheduledJob -RunNow @JobParameters -ErrorAction Stop

            Write-Debug "Get ScheduledJob"
            While (-Not($Job = Get-Job -Name $ScheduledJob.Name -ErrorAction SilentlyContinue)) { Sleep -m 100 }

            Write-Debug "Receive ScheduledJob"
            $Job | Wait-Job | Receive-Job -Wait -AutoRemoveJob

        } Catch { Throw $_ }
    }

    End {

        Write-Debug "Remove ScheduledJob"
        $ScheduledJob | Unregister-ScheduledJob -Force -Confirm:$False | Out-Null

    }

}