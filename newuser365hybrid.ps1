Read-Host "Run Me as a DA and as Administrator if so press Enter"
Read-Host "Make sure you have gone through the script and replaced % Values with correct"

################################## Import ActiveDirectory ##############################################
 
Import-Module ActiveDirectory
 
########################################################################################################
 
#Clear-host
 
# Gets all of the users info to be copied to the new account
#Checking the user to copy if it exist
	do {
$nameds = Read-Host "Copy From Username"
if (dsquery user -samid $nameds){"AD User Found"
}
 
elseif ($nameds = "null") {"AD User not Found"}
}
while ($nameds -eq "null")
 
#Checking if the new user exist
 
do {
 
$NewUserds = Read-Host "New Username"
 
While ( $NewUserds -eq "" ) { $NewUserds = Read-Host "New Username"}
$NewUser = $Newuserds
 
#check if AD user exist	
if (dsquery user -samid $NewUserds){"Ad User Exist"}
 
elseif ($NewUserds = "no") {"Validation OK"}
}
 
while ($Newuserds -ne "no")
 
 
# Gets all of the users info to be copied to the new account
 
$name = Get-AdUser -Identity $nameds -Properties *
 
$DN = $name.distinguishedName
$OldUser = [ADSI]"LDAP://$DN"
$Parent = $OldUser.Parent
$OU = [ADSI]$Parent
$OUDN = $OU.distinguishedName
$NewUser = Read-Host "New Username"
$firstname = Read-Host "First Name"
$Lastname = Read-Host "Last Name"
$position = Read-Host "Users Position"
$Password = Read-Host "New Password"
$SecurePassword = ConvertTo-SecureString $Password –asplaintext –force
$NewName = "$firstname $lastname"
$domain = "%companydomain%"
$newuserfinitial = $firstname.substring(0,1)
$OldNotes = $name.info
 
#Remove Spaces for Make Email Alias Correct
$Lastnamens = $Lastname -replace '\s',''
 
# Creates the user from the copied properties
 
New-ADUser -SamAccountName $NewUser -Name $NewName -GivenName $firstname -Surname $lastname -EmailAddress $newuserfinitial$Lastnamens@%companydomain%.com  -Instance $DN -Path "$OUDN" -AccountPassword $SecurePassword –userPrincipalName $NewUser@$domain -Company $name.Company -Department $name.Department -Manager $name.Manager -title $position -Description $position -HomePage $name.HomePage  -Office $name.Office -City $name.city -PostalCode $name.postalcode -Country $name.country -Fax $name.fax -State $name.State -StreetAddress $name.StreetAddress  -homedrive "H" -homedirectory "\\%company file share%\dfs\Home\$NewUser" -Enabled $true
 
# Set Profile Location
$NewUserAdDetails = Get-AdUser -Identity $NewUser -Properties *
$DN = $NewUserAdDetails.distinguishedName
$NewUserLdap = [ADSI]"LDAP://$DN"
$NewUserLdap.psbase.invokeset("terminalservicesprofilepath”,"\\%company file share%\dfs\tsprofiles\$NewUser")
$NewUserLdap.setinfo()
 
 
# gets groups from the Copied user and populates the new user in them
 
write-host "Copying Group Membership"
 
$groups = (GET-ADUSER –Identity $name –Properties MemberOf).MemberOf
foreach ($group in $groups) { 
 
Add-ADGroupMember -Identity $group -Members $NewUser
}
 
$count = $groups.count
 
#Check to see if new user is member of group and do things - Use Windows 2000 Name
$newusergroups = (GET-ADUSER –Identity $NewUser –Properties MemberOf).MemberOf
if ($newusergroups -match '#ADGROUP') { 
 
$currentuser = [Environment]::UserName
 
}
 
 
# Creates the New user Profile Folder
New-item \\%company file share%\dfs\profiles\"$NewUser" -type directory
$acl = Get-Acl \\%company file share%\dfs\profiles\"$NewUser"
$acl.GetAccessRules($true, $true, [System.Security.Principal.NTAccount])
$acl.SetAccessRuleProtection($true, $true)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule "domain\$NewUser","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"
$acl.addAccessRule($rule)
Set-Acl \\domain.local\dfs\profiles\"$NewUser" $acl
 
# Creates the New user TS Profile Folder
New-item \\%company file share%\dfs\tsprofiles\"$NewUser" -type directory
$acl = Get-Acl \\%company file share%\dfs\tsprofiles\"$NewUser"
$acl.GetAccessRules($true, $true, [System.Security.Principal.NTAccount])
$acl.SetAccessRuleProtection($true, $true)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule "domain\$NewUser","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"
$acl.addAccessRule($rule)
Set-Acl \\%company file share%\dfs\tsprofiles\"$NewUser" $acl

# Creates the New user Home Folder
New-item \\%company file share%\dfs\Home\"$newuser" -type directory
$acl = Get-Acl \\%company file share%\dfs\Home\"$NewUser"
$inheritanceFlags = ([Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit) 
$propagationFlags = [Security.AccessControl.PropagationFlags]::None 
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule "domain\$NewUser","FullControl",$inheritanceFlags, $propagationFlags,"Allow"
$acl.addAccessRule($rule)
Set-Acl \\%company file share%\dfs\home\"$NewUser" $acl
 
Set-AdUser -Identity $NewUser -Replace @{HomeDirectory="\\%company file share%\dfs\Home\$NewUser"}

$homedrivereadded = Read-Host "Now can you reset the homedrive as the script doesn't do a very good job"

repadmin /syncall /force

Start-Sleep -s 20

Read-Host "Logging Into HIT Exchange server use DA account and password "
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://hitexch/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session

Enable-MailUser -Identity $NewUser -ExternalEmailAddress $NewUser@%365domain%.onmicrosoft.com
Set-MailUser $NewUser -EmailAddressPolicyEnabled:$false
Set-MailUser $NewUser -PrimarySmtpAddress $NewUser@%companydomain%.com
Exit-PSSession

#Running AD Sync
Invoke-Command -ComputerName HITAZDC01 -ScriptBlock {Start-ADSyncSyncCycle -PolicyType Delta}

Start-Sleep -s 20

#Install https://www.microsoft.com/en-us/download/details.aspx?id=50395
#Install $x86 = ‘https://download.microsoft.com/download/4/1/A/41A369FA-AA36-4EE9-845B-20BCC1691FC5/PackageManagement_x86.msi’
#Install $x64 = ‘https://download.microsoft.com/download/4/1/A/41A369FA-AA36-4EE9-845B-20BCC1691FC5/PackageManagement_x64.msi’
#Install-Module -Name AzureAD
#Install-Module MsOnline 

Read-Host "Logging Into Azure AD with DA email address and password"
$NewUser = Read-Host "Username for new user account"
$msolcred = get-credential
connect-msolservice -credential $msolcred
Set-MsolUser -UserPrincipalName $NewUser@%companydomain%.com -UsageLocation "AU"
Set-MsolUserLicense -UserPrincipalName $NewUser@%companydomain%.com -AddLicenses %365account%:ENTERPRISEPACK

Start-Sleep -s 60

Read-Host "Logging Into 365 use DA email address and password"

#Install 365 2fa Module for Powershell https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps
Import-Module .\3652fapowershell\CreateExoPSSession.ps1
Connect-EXOPSSession

#enable archiving and retention and litigation hold
Enable-Mailbox $NewUser@%companydomain%.com -Archive
Set-Mailbox $NewUser@%companydomain%.com -RetentionPolicy "CorpPolicy"
Set-Mailbox $NewUser@%companydomain%.com -LitigationHoldEnabled $true

#Enable Auditing
Set-Mailbox $NewUser@%companydomain%.com -auditenabled $true -AuditOwner Update,Move,MoveToDeletedItems,SoftDelete,HardDelete,mailboxlogin,Create
#Set Default Calendar Permissions
Set-MailboxFolderPermission -Identity $NewUser@%companydomain%.com:\calendar -user Default -AccessRights Reviewer
Set-MailboxFolderPermission -Identity $NewUser@%companydomain%.com:\calendar -user Anonymous -AccessRights Reviewer

