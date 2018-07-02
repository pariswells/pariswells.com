$PSEmailServer = "%emailserver%"

Add-PSSnapin Citrix*

function QuerySessions($computer, $timeout)
{	

#Ping the server to make sure online
If (Test-Connection $computer -quiet) {

#Check RDP is Alive
  $job = Start-Job -ScriptBlock {param($computer) query session /server:$computer } -ArgumentList $computer
  Wait-Job $job -Timeout $timeout
  Stop-Job $job 
  $result = Receive-Job $job
  $processresult = query process /server:$computer
  if($result -eq $null -or $processjob -eq "Error enumerating processes" )
{Send-MailMessage -From "%emailfrom%" -to %emailto%" -Subject "Citrix Server Hung" -Body $computer}
  Remove-Job $job

}
#Else {Write 'Tango Down'}
}

$servers = Get-XAServer -BrowserName '%CitrixApplicationName%'| select ServerName

foreach ($server in $servers) {

QuerySessions -computer $server -timeout "5"

}

