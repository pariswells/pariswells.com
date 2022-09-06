#Sec Groups list in array "1","2"
$SG = "GroupName"

#To Grab All
#$SG = Get-AzureADGroup -All $true | Select DisplayName


$ZSourceDomain = "sourcedomain.com"
$CSourceDomain = "sourcedomain2.com"
$DestinationDomain = "destinationdomain3.com"

foreach($S in $SG){

#connect to source tenant , have to save creds if we are working with a lot of groups if not comment out $zpassword and $zpassword 
#https://sid-500.com/2020/12/01/powershell-connect-to-azure-with-stored-credentials/
$zpassword = ConvertTo-SecureString (Unprotect-CmsMessage -Path C:\Scripts\pwd.txt) -AsPlainText -Force
$zcred= New-Object System.Management.Automation.PSCredential ('XXXXXX', $zpassword)
Connect-AzureAD -credential $zcred


$List = @()
$List = Get-AzureADGroup -SearchString "$S"

$ZListMembers = @()
$ZListMembers = Get-AzureADGroupMember -ObjectId $List.ObjectId | Where-Object {$_.UserPrincipalName -like '*$ZSourceDomain'}

$ZListMembersUPN = @()
$ZListMembersUPN = $ZListMembers.UserPrincipalName

$CListMembers = @()
$CListMembers = Get-AzureADGroupMember -ObjectId $List.ObjectId | Where-Object {$_.UserPrincipalName -like '*$CSourceDomain'}

$CListMembersUPN = @()
$CListMembersUPN = $CListMembers.UserPrincipalName

#connect to source tenant , have to save creds if we are working with a lot of groups if not comment out $fpassword and $fpassword 
#connect to destination tenant Azure AD
#https://sid-500.com/2020/12/01/powershell-connect-to-azure-with-stored-credentials/
$fpassword = ConvertTo-SecureString (Unprotect-CmsMessage -Path C:\Scripts\fpwd.txt) -AsPlainText -Force
$fcred= New-Object System.Management.Automation.PSCredential ('XXXXXXX', $fpassword)
Connect-AzureAD -credential $fcred

New-AzureADGroup -DisplayName $List.DisplayName -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"

foreach($ZListMemberUPN in $ZListMembersUPN){


add-azureadgroupmember -Identity $List.DisplayName -Member $ZListMemberUPN.replace("$ZSourceDomain","$DestinationDomain")

}

foreach($CListMemberUPN in $CListMembersUPN){


add-azureadgroupmember -Identity $List.DisplayName -Member $CListMemberUPN.replace("$CSourceDomain","$DestinationDomain")

}



}
