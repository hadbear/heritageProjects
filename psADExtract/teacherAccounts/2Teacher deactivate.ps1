$Teachers = Import-Csv -Path C:\users\$env:USERNAME\desktop\staff.csv

ForEach ($Teacher in $Teachers)
{
$i++
write-host "$i"
If ($teacher.status -eq 2){
Disable-ADAccount -Identity $teacher.username
}
}