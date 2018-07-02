on error resume next
 
Set objShell = CreateObject("WScript.Shell")
 
'Disable auto update
regKey = "HKLM\SOFTWARE\JavaSoft\Java Update\Policy\EnableJavaUpdate"
regValue = 0 '0 Disable 1 Enable
 
objShell.RegWrite regKey, regValue, "REG_DWORD"
 
Set objShell = nothing