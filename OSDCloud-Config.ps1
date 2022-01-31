Write-Host  -ForegroundColor Cyan "Starting SeguraOSD's Custom OSDCloud ..."
Start-Sleep -Seconds 5

#Change Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Cyan "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

#Make sure I have the latest OSD Content
Write-Host  -ForegroundColor Cyan "Updating the awesome OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Cyan "Importing the sweet OSD PowerShell Module"
Import-Module OSD -Force

#TODO: Spend the time to write a function to do this and put it here
Write-Host  -ForegroundColor Cyan "Ejecting ISO"
Write-Warning "That didn't work because I haven't coded it yet!"
#Start-Sleep -Seconds 5

#Start OSDCloud ZTI the RIGHT way
Write-Host  -ForegroundColor Cyan "Start OSDCloud with MY Parameters"
Start-OSDCloud -OSLanguage en-gb -OSBuild 21H1 -OSEdition Pro -ZTI

#Install Windows updates before continueing with Autopilt join
$UpdateWindows =$true
if (!(Get-Module PSWindowsUpdate -ListAvailable)) {
    try {
        Install-Module PSWindowsUpdate -Force
    }
    catch {
        Write-Warning 'Unable to install PSWindowsUpdate Powershell Module'
        $UpdateWindows = $false
    }
}

if ($UpdateWindows) {
    Write-Host -Foregroundcolor DarkCyan 'Add-WUServiceManager -MicrosoftUpdate -Confirm:$false'
    Add-WUServiceManager -MicrosoftUpdate -Confirm:$false
    
    Write-Host -ForegroundColor DarkCyan 'Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot'
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot -NotTitle 'Malicious'
}note

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
