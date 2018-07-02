' Profile clean up - remove unneeded or old files before logoff
' --------------------------------------------------------------
' Original scripts:
'   http://www.wisesoft.co.uk/scripts/vbscript_recursive_file_delete_by_extension.aspx
'   http://ss64.com/vb/syntax-profile.html
'   http://csi-windows.com/toolkit/csigetspecialfolder
 
'   Version 2.0; 27/12/2011
 
Option Explicit
On Error Resume Next 'Avoid file in use issues
 
Dim strExtensionsToDelete, strAppData, strUserProfile, objFSO, strCookies, strHistory, strRecent, objShellApp
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShellApp = CreateObject("Shell.Application")
Const CSIDL_COOKIES = "&H21"
Const CSIDL_HISTORY = "&H22"
Const CSIDL_RECENT = "&H08"
Const CSIDL_NETHOOD = "&H13"
Const CSIDL_APPDATA = "&H1A"
Const CSIDL_PROFILE = "&H28"
 
' Folder to delete files from (files will also be deleted from Subfolders)
strUserProfile = objShellApp.NameSpace(cint(CSIDL_PROFILE)).Self.Path
strAppData = objShellApp.NameSpace(cint(CSIDL_APPDATA)).Self.Path
strCookies = objShellApp.NameSpace(cint(CSIDL_COOKIES)).Self.Path
strHistory = objShellApp.NameSpace(cint(CSIDL_HISTORY)).Self.Path
strRecent = objShellApp.NameSpace(cint(CSIDL_RECENT)).Self.Path
strNetHood = objShellApp.NameSpace(cint(CSIDL_NETHOOD)).Self.Path
 
' Main
RecursiveDeleteByExtension strAppData, "tmp,log"
RecursiveDeleteOlder 90, strCookies
RecursiveDeleteOlder 14, strRecent
RecursiveDeleteOlder 21, strHistory
RecursiveDeleteOlder 21, strNetHood
RecursiveDeleteOlder 14, strAppData & "\Microsoft\Office\Recent"
'RecursiveDeleteOlder 5, strAppData & "\Sun\Java\Deployment\cache"
'RecursiveDeleteOlder 3, strAppData & "\Macromedia\Flash Player"
'RecursiveDeleteOlder 14, strUserProfile & "\Oracle Jar Cache"
 
Sub RecursiveDeleteByExtension(ByVal strPath,strExtensionsToDelete)
    ' Walk through strPath and sub-folders and delete files of type strExtensionsToDelete
    Dim objFolder, objSubFolder, objFile, strExt
 
    If objFSO.FolderExists(strPath) = True Then
        Set objFolder = objFSO.GetFolder(strPath)
        For Each objFile in objFolder.Files
            For each strExt in Split(UCase(strExtensionsToDelete),",")
                If Right(UCase(objFile.Path),Len(strExt)+1) = "." & strExt then
                    WScript.Echo "Deleting: " & objFile.Path
                    objFile.Delete(True)
                    Exit For
                End If
            Next
        Next
        For Each objSubFolder in objFolder.SubFolders
            RecursiveDeleteByExtension objSubFolder.Path,strExtensionsToDelete
        Next
    End If
End Sub
 
Sub RecursiveDeleteOlder(ByVal intDays,strPath)
    ' Delete files from strPath that are more than intDays old
    Dim objFolder, objFile, objSubFolder
 
    If objFSO.FolderExists(strPath) = True Then
        Set objFolder = objFSO.GetFolder(strPath)
        For each objFile in objFolder.files
            If DateDiff("d", objFile.DateLastModified,Now) > intDays Then
                If UCase(objFile.Name) <> "DESKTOP.INI" Then  ' Ensure we don't delete desktop.ini
                    WScript.Echo "Deleting: " & objFile.Path
                    objFile.Delete(True)
                End If
            End If
        Next
        For Each objSubFolder in objFolder.SubFolders
            RecursiveDeleteOlder intDays,objSubFolder.Path
        Next
    End If
End Sub
