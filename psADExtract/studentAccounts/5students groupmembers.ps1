$group = Get-ADGroup -SearchBase "OU=Class groups,DC=ha,DC=edu" -filter *

foreach ($groupline in $group){Get-ADGroupMember $groupline.name -recursive| ForEach-Object {Remove-ADGroupMember $groupline.Name $_ -Confirm:$false}}

#Get-ADGroupMember $group.name | ForEach-Object {Remove-ADGroupMember  $_ -Confirm:$false}


#$groupuser = @()
 #foreach ($groupline in $group){
 #$groupusers = Get-ADGroupMember -identity $groupline.Name -verbose

 #Remove-ADGroupMember -identity $groupline.Name -members *
 #}
write-host "Still processing groups"

foreach($line in import-csv -path "$env:userprofile\desktop\students.csv"){
Add-ADGroupMember -Identity $line.ADgroupname -Members $line.login ##-ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
}

#Get-ADGroupMember -identity $groupline.name|