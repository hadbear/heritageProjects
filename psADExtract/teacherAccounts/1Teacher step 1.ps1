$b = "[^a-z]"
$c = "[[.*\]]"
$server = hostname
[int]$i = ""
$FacultyOU = "OU=faculty,DC=ha,DC=edu"
$a = $null
$allusers = 'allstaff'
$mesa = 'Mesastaff'
$laveen = 'Laveenstaff'
$gateway = 'Gatewaystaff'
$faculty = 'Faculty'
$password = 'Heritage1'
##clean Headers if needed
$filename = "$env:USERPROFILE\desktop\staff.text"


(Get-Content $filename -Raw) -ireplace ("$c", "") |
  Set-Content $filename

##import user data
##
$Teachers = Import-Csv -Path $filename -Delimiter ","

#$staffmember = $null

# Declare an array to collect our result objects
$Staffmember =@()

ForEach ($Teacher in $Teachers)
{
## clean and establish each object
$info = New-Object pscustomobject

##Firstname
$Firstname = [regex]::match(($Teacher.First_Name), [regex]"\((.*)\)").Groups[1]
if ($a -match $Firstname){
$Firstname = $teacher.First_Name
}
$userFirstname = $userFirstname -ireplace("$b","")

##LastName
$LastName = [regex]::match(($teacher.Last_Name), [regex]"\((.*)\)").Groups[1]
if ($a -match $LastName)
{
$LastName = $teacher.Last_Name
}
$LastName = $LastName -ireplace("$b","")

##School location
$location = $teacher.SchoolID
##Status
$status = $teacher.status
##user name
$username = $teacher.Email_Addr -ireplace("\@heritageacademyaz\.com", "")
$username = $username -ireplace("\@heritageacademyazcom", "")
##home directory
#$teacherdirectory = "C:\home\" + "Teachers" + "\" + $username
#$homedirectory =  "\" + "\" + $server + "\" + "Teachers" + "\" + $username
## ad displayname
$ADdisplayname = "$Firstname" + " " + "$LastName"
##email
$email = $teacher.email_addr

$info | add-member -membertype NoteProperty -name "Firstname" -Value $Firstname
$info | add-member -membertype NoteProperty -name "Lastname" -Value $lastname
$info | add-member -membertype NoteProperty -name "email" -Value $email
$info | add-member -membertype NoteProperty -name "Location" -Value $Location
$info | add-member -membertype NoteProperty -name "status" -Value $status
$info | add-member -membertype NoteProperty -name "username" -Value $username
#$info | add-member -membertype NoteProperty -name "homedirectory" -Value $homedirectory
#$info | add-member -membertype NoteProperty -name "Teacherfolder" -Value $Teacherfolder
$info | add-member -membertype NoteProperty -name "FacultyOU" -Value $FacultyOU
$info | add-member -membertype NoteProperty -name "ADdisplayname" -Value $ADdisplayname


$Staffmember += $info
##Write-Progress -Activity "Sorting data, checking users, adding users, adding to groups" -Status "Percent Complete $j" -PercentComplete ($j)
}
$Staffmember| Export-csv -path C:\users\$env:USERNAME\desktop\staff.csv -notypeinformation