$Teachers = Import-Csv -Path C:\users\$env:USERNAME\desktop\staff.csv

$mesa = 'Mesastaff'
$laveen = 'Laveenstaff'
$gateway = 'Gatewaystaff'

ForEach ($Teacher in $Teachers)
{

If (($Teacher.location -eq 1) -and ($Teacher.status -eq 2)){
Remove-ADGroupMember -Identity $mesa -Members $Teacher.username -Confirm $false
}
elseIf (($Teacher.location -eq 2) -and ($Teacher.status -eq 2)){
Remove-ADGroupMember -Identity $gateway -Members $Teacher.username -Confirm $false
}
elseIf (($Teacher.location -eq 3) -and ($Teacher.status -eq 2)){
Remove-ADGroupMember -Identity $laveen -Members $Teacher.username -Confirm $false
}
else {}
}