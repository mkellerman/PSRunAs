
Import-Module .\Copy-Function\Copy-Function.ps1
Import-Module .\Invoke-ExpressionAs_Invoke-ScheduledJob\Invoke-ExpressionAs_Invoke-ScheduledJob.ps1

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
