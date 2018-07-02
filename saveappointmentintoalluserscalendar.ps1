#Import file of Holidays Set Out with Country,Date, Holiday Titles
$file = Import-Csv -Path "C:\scripts\publicholiday2015.csv"
 
#Declare Country to Import
$Country = "Australia"
 
# set Group Name to Import to
$group = "#GroupName"
 
 
  #Recursive Group Search due to Issue of Groups Inside of Groups for Melboure
    function getMembership($group) {
        $searchGroup = Get-DistributionGroupMember $group -ResultSize Unlimited
        foreach ($member in $searchGroup) {
            if ($member.RecipientTypeDetails-match "Group" -and $member.DisplayName -ne "") {
                getMembership($member.DisplayName)
                }           
            else {
                if ($member.DisplayName -ne "") {
 
      $mailAddress = $member.PrimarySmtpAddress.ToString();
      Write-Host "Accessing mailbox" $mailAddress
      Write-Output "Accessing mailbox $mailAddress"
      Write-Host "Importing holidays for" $Country
      Write-Output "Importing holidays for $Country"
      [String] $dllPath = "C:\Program Files (x86)\Microsoft\Exchange\Web Services
 
\2.1\Microsoft.Exchange.WebServices.dll"
      [Void] [Reflection.Assembly]::LoadFile($dllPath)
 
      $Service = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService
 
([Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2010_SP2)
      #$Service.AutodiscoverUrl($mbxName, {$True})
      $Service.ImpersonatedUserId = New-Object
 
Microsoft.Exchange.WebServices.Data.ImpersonatedUserId([Microsoft.Exchange.WebServices.Data.ConnectingIdType]::SmtpAddress,
 
$mailAddress);
      #$Service.UseDefaultCredentials = true;
      $Service.Url = new-Object Uri
 
("https://exchangeservername/ews/exchange.asmx")
 
      # This is the root folder from where we want to start searching for the
 
folder we want to delete.
      # Once we find it, then we will go recursively down that folder.
      # Other option would be to get the FolderID and start the search straight
 
from there
      $CalendarFolderId = new-object Microsoft.Exchange.WebServices.Data.FolderId
 
([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Calendar, $mailAddress)
      #$RootFolderID = new-object Microsoft.Exchange.WebServices.Data.FolderId
 
([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Root, $mbxName)
      $CalendarFolder = [Microsoft.Exchange.WebServices.Data.Folder]::Bind
 
($Service, $CalendarFolderId)
 
      foreach ($line in $file)
      {
       if ($line.Country -eq $Country)
       {
       Write-Host "Holiday name and date: " $line.Holiday $line.Date
       Write-Output "Holiday name and date:" $line.Holiday $line.Date
        $SearchFilterCollection = New-Object
 
Microsoft.Exchange.WebServices.Data.SearchFilter+SearchFilterCollection
 
([Microsoft.Exchange.WebServices.Data.LogicalOperator]::And)
        $SearchFilter1 = new-object
 
Microsoft.Exchange.WebServices.Data.SearchFilter+IsEqualTo
 
([Microsoft.Exchange.WebServices.Data.AppointmentSchema]::Subject,$line.Holiday)
        $Start = new-object System.DateTime
          $Start = $Start = [System.DateTime]::Parse($line.Date)
        $SearchFilter2 = new-object
 
Microsoft.Exchange.WebServices.Data.SearchFilter+IsEqualTo([Microsoft.Exchange.WebServices.Data.AppointmentSchema]::Start,
 
$Start)
        $SearchFilterCollection.Add($SearchFilter1)
        $SearchFilterCollection.Add($SearchFilter2)
 
        $itemView = new-object
 
Microsoft.Exchange.WebServices.Data.ItemView(20)
        $itemView.PropertySet = new-object
 
Microsoft.Exchange.WebServices.Data.PropertySet([Microsoft.Exchange.WebServices.Data.BasePropertySet]::FirstClassProperties)
 
        $findResults = $Service.FindItems
 
([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Calendar,$SearchFilterCollection,$itemView)
 
        if ($findResults.Items.Count -eq 0)
        {
         $Appointment = New-Object
 
Microsoft.Exchange.WebServices.Data.Appointment -ArgumentList $service  
         #Set Subject  
         $Appointment.Subject = $line.Holiday
         #Set Start Time  
         $Appointment.Start = [System.DateTime]::Parse
 
($line.Date)
         #Set Start Time  
         $Appointment.End = [System.DateTime]::Parse
 
($line.Date).AddDays(1)
         #Mark as all day event 
         $Appointment.IsAllDayEvent = $true;
         #Add Country to Item
         $Appointment.Location = $line.Country
         #Change Category to Holiday
         $Appointment.Categories.Add(‘Holiday’)
         #Show as free
         $Appointment.LegacyFreeBusyStatus =
 
[Microsoft.Exchange.WebServices.Data.LegacyFreeBusyStatus]::Free;
         #Create Appointment will save to the default
 
Calendar  
         $Appointment.Save($CalendarFolderId,SendInvitationsMode.SendToNone)
         Write-Host "Element created!"
         Write-Output "Element created!"
        }
        else
        {
         Write-Host "Holiday exists!"
         Write-Output "Holiday exists!"
 
         #Uncomment Below to delete Holidays in Users
 
Calendar if they exist
        #foreach($item in $findResults.Items)
         #{ 
         #    $item.Load()
         #    $item.Delete
 
([Microsoft.Exchange.WebServices.Data.DeleteMode]::HardDelete)
         #    Write-Host "Element deleted!"
         #    Write-Output "Element deleted!"
         #}
        }
       }
      }
 
 
 
 
 
                    }
                }
            }
 
        }
 
## Run the function
    getMembership($group)
 
 
$findResults = $null
$itemView = $null
$SearchFilter1 = $null
$SearchFilter2 = $null
$SearchFilderCollection = $null
$CalendarFolder = $null
$CalendarFolderId = $null
$Service = $null
