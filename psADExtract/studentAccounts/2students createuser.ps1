$ErrorActionPreference= 'silentlycontinue'
$students = Import-Csv -Path "$env:userprofile\desktop\students.csv"
$password = "Student1"
$i = [int] 0

$totalcount = $students | Measure-Object 
$totalcount = $totalcount.count
foreach ($student in $students){
$i++
$j = (($i / $totalcount) * 100)
New-ADUser -Name $student.login -DisplayName $student.Display -SamAccountName $student.login -UserPrincipalName $student.Userprincipalname -GivenName $student.Firstname -Surname $student.Lastname  -EmailAddress $student.studentemail -Path $student.OUlocation -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
Write-Progress -Activity "Step 2" -Status "Percent Complete $j" -PercentComplete ($j)

}
#Set-ADUser -Identity $username -HomeDirectory $adhomefolder -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#Set-ADUser -Identity $userteacher -HomeDirectory $teacherHomedirectory -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#Set-ADUser -Identity $username -UserPrincipalName $upn
#Set-ADGroup -Identity $ADgroupname -ManagedBy $userteacher