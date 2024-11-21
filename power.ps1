Write-Host @"
=======================================
    ___    __        _       ___ _______ 
   /   |  / /______ | |     / (_) ____(_)
  / /| | / //_/ __ `/ | /| / / / /_  / / 
 / ___ |/ ,< / /_/ /| |/ |/ / / __/ / /  
/_/  |_/_/|_|\__,_/ |__/|__/_/_/   /_/   
                                         
=======================================
Fuck you bitch ass NIGGER
======================================="
"@ -ForegroundColor Cyan

# Run as administrator check
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
    Write-Warning "Please run this script as an Administrator!"
    Break
}

# Create PowerThrottling key and disable power throttling
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "PowerThrottling" -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1 -PropertyType DWORD -Force

# Modify power settings attributes
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" -Name "Attributes" -Value 2 -PropertyType DWORD -Force

Write-Host "=======================================
Registry modifications completed successfully. 
Please restart your computer for changes to take effect.
=======================================" -ForegroundColor Green