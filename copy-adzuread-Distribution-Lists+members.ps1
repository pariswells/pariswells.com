#Connect with source tenant
Connect-AzureAD

#Connect with destination tenant
Connect-ExchangeOnline


#Dist Groups list in array "1","2"
$DL = "1","2"


$ZSourceDomain = "sourcedomain.com"
$CSourceDomain = "sourcedomain2.com"
$DestinationDomain = "destinationdomain3.com"

foreach($D in $DL){
    
   $List = @()
   $List = Get-AzureADGroup -SearchString "$D"
   #Remove office 365 Groups with same name , using SPO as identifier
   $List = $list | ?{$_.proxyaddresses -match '.*SPO.*'}
 
   $ZListMembers = @()
   $ZListMembers = Get-AzureADGroupMember -ObjectId $List.ObjectId | Where-Object {$_.UserPrincipalName -like '*$ZSourceDomain'}

   $ZListMembersUPN = @()
   $ZListMembersUPN = $ZListMembers.UserPrincipalName

   $CListMembers = @()
   $CListMembers = Get-AzureADGroupMember -ObjectId $List.ObjectId | Where-Object {$_.UserPrincipalName -like '*$CSourceDomain'}

   $CListMembersUPN = @()
   $CListMembersUPN = $CListMembers.UserPrincipalName


   New-DistributionGroup -Name $List.DisplayName -Description $List.Description -PrimarySmtpAddress $($List.MailNickName+"@$DestinationDomain")
    
   foreach($ZListMemberUPN in $ZListMembersUPN){
   
               
        Add-DistributionGroupMember -Identity $List.DisplayName -Member $ZListMemberUPN.replace("$ZSourceDomain","$DestinationDomain")
        
        }
   
   foreach($CListMemberUPN in $CListMembersUPN){
   
               
        Add-DistributionGroupMember -Identity $List.DisplayName -Member $CListMemberUPN.replace("$CSourceDomain","$DestinationDomain")
        
        }
   
   
   

}
