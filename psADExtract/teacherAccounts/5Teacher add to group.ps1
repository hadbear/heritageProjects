$Teachers = Import-Csv -Path C:\users\$env:USERNAME\desktop\staff.csv

$mesa = 'Mesastaff'
$laveen = 'Laveenstaff'
$gateway = 'Gatewaystaff'

ForEach ($Teacher in $Teachers)
{

If (($Teacher.location -eq 1) -and ($Teacher.status -eq 1)){
Add-ADGroupMember -identity $mesa -members $Teacher.username
}
elseIf (($Teacher.location -eq 2) -and ($Teacher.status -eq 1)){
Add-ADGroupMember -identity $gateway -members $Teacher.username
}
elseIf (($Teacher.location -eq 3) -and ($Teacher.status -eq 1)){
Add-ADGroupMember -identity "$Laveen" -members $Teacher.username
}
else {}
}