$file = import-csv -path "$env:userprofile\desktop\students.csv"
$ErrorActionPreference= 'silentlycontinue'
$i = [int] 0
$totalcount = $file | Measure-Object 
$totalcount = $totalcount.count
foreach($line in $file){
$i++
$j = (($i / $totalcount) * 100)
New-ADGroup -DisplayName $line.ADgroupname -Name $line.ADgroupname -Path "OU=Class groups,DC=ha,DC=edu" -GroupCategory Security -GroupScope 0 -SamAccountName $line.ADgroupname -OtherAttributes @{'mail'=$line.GroupEmail} -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null 
Set-ADGroup -Identity $line.ADgroupname -ManagedBy $line.teacher
Write-Progress -Activity "Step 4" -Status "Percent Complete $j" -PercentComplete ($j)

}


#New-ADGroup -DisplayName $line.ADgroupname -Name $line.ADgroupname -Path "OU=Class groups,DC=ha,DC=edu" -GroupCategory Security -GroupScope Global -SamAccountName $line.ADgroupname -OtherAttributes @{'mail'=$line.GroupEmail} -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
