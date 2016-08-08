$Teachers = Import-Csv -Path C:\users\$env:USERNAME\desktop\staff.csv

ForEach ($Teacher in $Teachers)
{

If ($Teacher.status -eq 1){
Enable-ADAccount -Identity $Teacher.username
}
}