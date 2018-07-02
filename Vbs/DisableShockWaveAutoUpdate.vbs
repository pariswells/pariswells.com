on error resume next
 
Set objShell = CreateObject("WScript.Shell")
 
'Disable auto update
regKey = "HKLM\SOFTWARE\Adobe\Shockwave 11\AutoUpdate\"
regValue = "n"
 
objShell.RegWrite regKey, regValue, "REG_SZ"
 
Set objShell = nothing