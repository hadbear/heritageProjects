$Teachers = Import-Csv -Path C:\users\$env:USERNAME\desktop\staff.csv

$FacultyOU = "OU=faculty,DC=ha,DC=edu"
$allusers = 'allstaff'
$mesa = 'Mesastaff'
$laveen = 'Laveenstaff'
$gateway = 'Gatewaystaff'
$faculty = 'Faculty'
$password = 'Heritage1'

ForEach ($Teacher in $Teachers)
{
$check = $null
$check = get-aduser $teacher.username
if ($check -eq $null){

If (($Teacher.status -eq 1) -and ($Teacher.username -ne $null) -and ($Teacher.username -ne ""))##-and ($exist -ne "True"))
{
new-aduser -name ($Teacher.firstname + " " + $Teacher.lastname) -displayname ($Teacher.firstname + " " + $Teacher.lastname) -samaccountname $Teacher.username -UserPrincipalName ($Teacher.username + '@ha.edu') -GivenName "$Teacher.Firstname" -Surname "$Teacher.LastName" -path "$facultyou" -AccountPassword (ConvertTo-SecureString "Heritage1" -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true
Set-aduser -identity "$Teacher.username" -EmailAddress ($Teacher.username + '@heritageacademyaz.com')
Add-ADGroupMember -identity "$allusers" -members $Teacher.username
Add-ADGroupMember -identity "$faculty" -members $Teacher.username
}
else{}
}}