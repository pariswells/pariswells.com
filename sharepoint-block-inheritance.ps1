Install-Module SharePointPnPPowerShellOnline -AllowClobber

$web = Get-PnPWeb -Connection (Connect-PnPOnline "https://XXXXXX.sharepoint.com/sites/XXXXXXX/" -Credentials $cred -ReturnConnection)

$list = Get-PnPList "Document Library" -Web $web

$list.BreakRoleInheritance($true, $true)

$list.Update()

$list.Context.Load($list)

$list.Context.ExecuteQuery()
