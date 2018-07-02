' #############################################################################
' Written in VBScript.
' Name: PrintSVRMigrate.vbs
' Author: .:. 24-Jul-2005
' Purpose: Modify Printer Connections
' Comment: Edit this file as neccessary, before making available to users.  
'   Comment out any lines not needed.  Only things you should need To
'   modify are the printer paths.  Read comments before each line of
'   code to see what it's doing.
' ############################################################################
'
' ==========================================
' Declaring variables - Declare everything!
' This ensures we only use variables that we
' mean to - do not modify.
' ==========================================
Option Explicit
Dim WshNetwork
 
Dim objNetwork
Dim colprinters
Dim PrinterName
Dim i
Dim oldPrinter 
Dim newPrinter
Dim printerfound
 
' Get a list of currently connected printers 
' and scan for the ones we need to change. 
' Process each printer as it is found.

Set objNetwork = WScript.CreateObject("WScript.Network")
Set colPrinters = objNetwork.EnumPrinterConnections
  
  'Repeat this line for multiple printers -------------------->
  
' Old printer share will be case sensitive.
For i = 0 to colPrinters.Count -1 Step 2
  printerfound = "no"
 If colprinters.Item (i + 1) = "\\printerserver\oldprinter" Then 
     oldPrinter = "\\printerserver\oldprinter"
     newPrinter = "\\printerserver\newprinter"
     printerfound = "yes"
 End If
 
If printerfound = "yes" Then
   SwapPrinter
End If 

Next
 
 'Repeat this line for multiple printers -------------------->
 
 
 ' Uncomment below if you want to delete any rather than swap sharewillbecasesensitive
' For i = 0 to colPrinters.Count -1 Step 2
'   printerfound = "no"
'  If colprinters.Item (i + 1) = "\\printertobedeleted\" Then 
'      oldPrinter = "\\printertobedeleted\"
'      printerfound = "yes"
'  End If
'   
' If printerfound = "yes" Then
'    DelPrinter
' End If
'
'Next

 
WScript.Echo "Printer conversion is now complete"
 
WScript.quit
 
'*****************************
' Begin Subroutines
'*****************************

'******************
Sub  SwapPrinter 
 
Set WshNetwork = CreateObject("WScript.Network")
 
 
 
' This line will add the specified printer. You can add more printers if needed.
WshNetwork.AddWindowsPrinterConnection newPrinter
 
' This line sets the user's default printer.
' WshNetwork.SetDefaultPrinter $newPrinter

' This line removes the specified printer.
WshNetwork.RemovePrinterConnection oldPrinter
 
' If any steps are not needed, comment them out by adding a single quote to the 
' beginning of a line - like this one.

End Sub
  
Sub  DelPrinter 

Set WshNetwork = CreateObject("WScript.Network")


' This line removes the specified printer.
WshNetwork.RemovePrinterConnection oldPrinter

' If any steps are not needed, comment them out by adding a single quote to the 
' beginning of a line - like this one.

End Sub
