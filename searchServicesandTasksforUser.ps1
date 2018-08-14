#run this script as administrator
#create a servers.txt for all the servers you want to query
$Servers = Get-Content servers.txt
#add * infront and behind username for wildcard
$user = "*huonit*"

$findings = foreach ($computername in $Servers){

    $schtask = schtasks.exe /query /s $computername /V /FO CSV | ConvertFrom-Csv | Where { $_."Run As User" -like $user} | Select TaskName
    if ($schtask) {Write-Host "`nTask" + $computername + $schtask }
   
    $displayname = Get-WmiObject -class win32_service -computername $computername |where-object startname -like $user | Select displayname
    if ($displayname){Write-Host "`nService" + $computername + $displayname }
   
}
