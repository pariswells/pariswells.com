on error resume next
 
Set objShell = CreateObject("WScript.Shell")
 
'Remove speed starter from the registry
regKey = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Adobe Reader Speed Launcher"
objShell.RegDelete regKey
 
'Disable auto update
regKey = "HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\9.0\FeatureLockdowng\bUpdater"
regValue = 0 'Disable
 
Set objShell = nothing