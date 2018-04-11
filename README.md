# PSRunAs

Collection of scripts to Invoke an expression with different credentials.

Each script comes with it's own Invoke-ExpressionAs wrapper.

A prefered solution is offered here:
https://github.com/mkellerman/Invoke-CommandAs
https://www.powershellgallery.com/packages/Invoke-CommandAs

---
## Invoke-ScheduledJob

Create a ScheduledTask using the provided credentials (Providing the credential is optional).

IMPORTANT: See Invoke-CommandAs implementation for a full solution.

### Example

```
Import-Module .\Invoke-ScheduledJob\Invoke-ExpressionAs.psm1

$Credential = Get-Credential
Invoke-ExpressionAs -Command "& cmd /c notepad.exe" -Credential $Credential
```

---
## Invoke-RunAs

Functionally equivalent to Windows "runas.exe", using Advapi32::CreateProcessWithLogonW
(also used by runas under the hood). Uses Add-Type to load the DLL directly in Powershell. 

No EXE required.

### Example

```
Import-Module .\Invoke-RunAs\Invoke-ExpressionAs.ps1

$Credential = Get-Credential
Invoke-ExpressionAs -Command "& cmd /c notepad.exe" -Credential $Credential
```

---
## Start-ProcessAsUser

Functionally equivalent to Windows "runas.exe", using Advapi32::CreateProcessWithLogonW 
(also used by runas under the hood). Uses Reflection to load the methods from DLL directly 
in Powershell. 

No EXE required.

### Example

```
Import-Module .\Start-ProcessAsUser\Invoke-ExpressionAs.ps1

$Credential = Get-Credential
Invoke-ExpressionAs -Command "& cmd /c notepad.exe" -Credential $Credential
```

---
## Invoke-CmdAs

Functionally equivalent to Windows "runas.exe", using Advapi32::CreateProcessWithLogonW 
(also used by runas under the hood). Uses a modified version of JetBean.runas.exe, with 
LOGON_NETCREDENTIALS_ONLY. 

IMPORTANT: An EXE is required. Will get downloaded from this Repo.

### Example

```
Import-Module .\Invoke-CmdAs\Invoke-ExpressionAs.ps1

$Credential = Get-Credential
Invoke-ExpressionAs -Command "& cmd /c notepad.exe" -Credential $Credential
```

---
## Example of Invoke-CmdAs function on remote machine

```
Import-Module .\Copy-Function\Copy-Function.ps1
Import-Module .\Invoke-CmdAs\Invoke-ExpressionAs.ps1

# Establish PSSession to remote machine.
$ComputerName = 'WIN-REMOTEMACHINE' 
$Credential = Get-Credential
$PSSession = New-PSSession -ComputerName $ComputerName -Credential $Credential

# Copy the Function to the remote session.
Copy-Function -Session $PSSession -Name 'Invoke-ExpressionAs'

# Invoke-ExpressionAs in the remote session.
Invoke-Command -Session $PSSession -ScriptBlock { 

    $Command = "& cmd /c notepad.exe"
    Invoke-ExpressionAs -Credential $Using:Credential -Command $Command

}
```
