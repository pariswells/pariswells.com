$Writers = @(vssadmin list writers | Select-String -Context 0,4 '^writer name:' | 
Select @{Label="Writer"; Expression={$_.Line.Trim("'").SubString(14)}}, 
   @{Label="WriterID"; Expression={$_.Context.PostContext[0].Trim().SubString(11)}},
   @{Label="InstanceID"; Expression={$_.Context.PostContext[1].Trim().SubString(20)}},
   @{Label="State"; Expression={$_.Context.PostContext[2].Trim().SubString(11)}},
   @{Label="LastError"; Expression={$_.Context.PostContext[3].Trim().SubString(12)}}) | 
% {if($_.LastError -ne "No error"){Write-Host $_.Writer}}
