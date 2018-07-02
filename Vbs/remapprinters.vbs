Const ForWriting = 2
 
Set objNetwork = CreateObject("Wscript.Network")
 
strComputer = "."
 
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
 
Set DefPrinters = objWMIService.ExecQuery _
     ("Select * from Win32_Printer Where Local = FALSE AND Default = True")
 
For Each DefPrinter in DefPrinters
    strText = strText & "Default : " & DefPrinter.Name & vbCrLf
Next
 
Set colPrinters = objWMIService.ExecQuery _
    ("Select * From Win32_Printer Where Local = FALSE AND Default = False")
 
For Each objPrinter in colPrinters
    strText = strText & objPrinter.Name & vbCrLf
Next
 
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set WshShell = WScript.CreateObject("WScript.Shell")
strDirectory = objFSO.BuildPath(WshShell.SpecialFolders("Desktop"), "Printers.txt")
 
Set objFile = objFSO.CreateTextFile _
    (strDirectory, ForWriting, True)
 
 
objFile.Write strText
 
objFile.Close
 
 
Const HKEY_CLASSES_ROOT  = &H80000000
Const HKEY_CURRENT_USER  = &H80000001
Const HKEY_LOCAL_MACHINE = &H80000002
Const HKEY_USERS         = &H80000003
 
' Object used to get StdRegProv Namespace
Set wmiLocator = CreateObject("WbemScripting.SWbemLocator")
 
' Object used to determine local machine name
Set wshNetwork = CreateObject("WScript.Network")
 
' Registry Provider (StdRegProv) lives in root\default namespace.
Set wmiNameSpace = wmiLocator.ConnectServer(wshNetwork.ComputerName, "root\default")
Set objRegistry = wmiNameSpace.Get("StdRegProv")
 
' Deletes Key with alle subkeys
sPath = "Printers"
 
lRC = DeleteRegEntry(HKEY_CURRENT_USER, sPath)
 
Function DeleteRegEntry(sHive, sEnumPath)
' Attempt to delete key.  If it fails, start the subkey
' enumration process.
lRC = objRegistry.DeleteKey(sHive, sEnumPath)
 
' The deletion failed, start deleting subkeys.
If (lRC <> 0) Then
 
' Subkey Enumerator
   On Error Resume Next
 
   lRC = objRegistry.EnumKey(HKEY_CURRENT_USER, sEnumPath, sNames)
 
   For Each sKeyName In sNames
      If Err.Number <> 0 Then Exit For
      lRC = DeleteRegEntry(sHive, sEnumPath & "\" & sKeyName)
   Next
 
   On Error Goto 0
 
' At this point we should have looped through all subkeys, trying
' to delete the registry key again.
   lRC = objRegistry.DeleteKey(sHive, sEnumPath)
 
End If
 
End Function
 
Const ForReading = 1
Const TristateUseDefault=-2
Set wshnet = CreateObject("Wscript.Network")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set WshShell = WScript.CreateObject("WScript.Shell")
strDirectory = objFSO.BuildPath(WshShell.SpecialFolders("Desktop"), "Printers.txt")
 
Set objFile = objFSO.OpenTextFile (strDirectory, ForReading, True, TristateUseDefault)
 
Do Until objFile.AtEndOfStream
              strNextLine = objFile.Readline
              if left(strNextLine,10) = "Default : " THEN
                             strNextLine = replace(strNextLine, "Default : ", "")            
                             wshnet.AddWindowsPrinterConnection strNextLine
                             wshnet.SetDefaultPrinter strNextLine
              END IF
              wshnet.AddWindowsPrinterConnection strNextLine
Loop
 
objFile.Close
 
x=msgbox("Printer ReMap Complete" ,0, "Tech Services")
