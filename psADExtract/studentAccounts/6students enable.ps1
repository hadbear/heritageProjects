$file = import-csv -path "$env:userprofile\desktop\students.csv"
$ErrorActionPreference= 'silentlycontinue'
$i = [int] 0
$totalcount = $file | Measure-Object 
$totalcount = $totalcount.count
foreach($line in import-csv -path "$env:userprofile\desktop\students.csv"){
$i++
$j = (($i / $totalcount) * 100)
Enable-ADAccount -identity $line.login
Write-Progress -Activity "Step 6" -Status "Percent Complete $j" -PercentComplete ($j)

}