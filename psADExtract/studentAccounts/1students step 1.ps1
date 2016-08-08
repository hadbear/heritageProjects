$b = "[^a-z]"
$l = "10" #name length
$c = "[[.*\]]"
$server = hostname
$y2 = "1"
$y = ""
$yy = ""
$ss = ""# to clear variable if ran twice
[int]$i = ""
$filename = "$env:userprofile\desktop\students.text"

##clean headers
(Get-Content $filename -Raw) -ireplace ("$c", "") | Set-Content $filename

$Users = Import-Csv -Path $filename -Delimiter ","

$Students =@()

$ss = Get-date -UFormat "%m"
$y = Get-Date -UFormat "%Y"
if ($ss -lt "05"){
$s ="Spring"}
else {$s = "Fall"}
$year = "$s" + "$y"

$totalcount = $users | Measure-Object 
$totalcount = $totalcount.count

ForEach ($user in $users){
$i++
$j = (($i / $totalcount) * 100)
$info = new-object PSObject

$Expression = $user."4Expression" -creplace("[()]","")

$location = $user."4SchoolID"

#$UserFirstname = $User.'FirstName'
$UserFirstname = [regex]::match(($User."1First_Name"), [regex]"\((.*)\)").Groups[1]
if ($a -match $UserFirstname){
$userFirstname = $User."1First_Name"
}
$userFirstname = $userFirstname -ireplace("$b","")
#$userLastName = $user.LastName
$userLastName = [regex]::match(($user."1Last_Name"), [regex]"\((.*)\)").Groups[1]
if ($a -match $UserLastName)
{
$userLastName = $user."1Last_Name"
}
$userLastName = $userLastName -ireplace("$b","")

$userteacher = $user."5Email_Addr" -ireplace("\@heritageacademyaz\.com", "")
$userteacher = $userteacher -ireplace("\@heritageacademyazcom", "")
$class = $user."2Course_Name" -ireplace("$b","")

$studentnumber = $user."1Student_Number"

if ($userfirstname.length -lt $l){$username = $userFirstname.substring(0,$userfirstname.length) + "." + "$studentnumber"}
else {$username = $userFirstname.substring(0,$l) + "." + "$studentnumber"}

$ADdisplayname = "$UserFirstname" + " " + "$userLastName"



$ADgroupname = $userteacher + $year + $expression

$classfolder = $class + $Expression

if ($location -eq 1){$oulocation = "OU=students,OU=Mesa,DC=ha,DC=edu"}
elseif ($location -eq 2){$oulocation = "OU=students,OU=Gateway,DC=ha,DC=edu"}
else{$oulocation = "OU=Students,OU=Laveen,DC=ha,DC=edu"}

$upn = $username + '@ha.edu'
$studentemail = $username + "@hastudents.us"
$Password = 'Student1' 
$teacherdirectory = "C:\home\" + "Teachers" + "\" + $userteacher + "\" + $year + "\" +$classfolder
$teacherHomedirectory = "\" + "\" + $server + "\" + "Teachers" + "\" + $userteacher
$Studentdirectory = "C:\home\Studentdata\" + "$ADdisplayname"
$ADhomefolder = "\" + "\" + $server + "\" + "Studentdata" + "\" + $year + "\" + "$ADdisplayname"

$groupEmail = $ADgroupname + "@hastudents.us"

$info | add-member -membertype NoteProperty -name "Firstname" -Value $UserFirstname
$info | add-member -membertype NoteProperty -name "Lastname" -Value $userLastName
$info | add-member -membertype NoteProperty -name "Period" -Value $Expression
$info | add-member -membertype NoteProperty -name "Teacher" -Value $userteacher
$info | add-member -membertype NoteProperty -name "Class" -Value $class
$info | add-member -membertype NoteProperty -name "StudNumb" -Value $studentnumber
$info | add-member -membertype NoteProperty -name "Login" -Value $username
$info | add-member -membertype NoteProperty -name "Display" -Value $ADdisplayname
$info | add-member -membertype NoteProperty -name "LocationID" -Value $location
$info | add-member -membertype NoteProperty -name "OUlocation" -Value $OUlocation
$info | add-member -membertype NoteProperty -name "Year" -Value $year
$info | add-member -membertype NoteProperty -name "ADGroupName" -Value $ADgroupname
$info | add-member -membertype NoteProperty -name "ClassFolder" -Value $classfolder
$info | add-member -membertype NoteProperty -name "Teacherdirectory" -Value $Teacherdirectory
$info | add-member -membertype NoteProperty -name "Studentdirectory" -Value $Studentdirectory
$info | add-member -membertype NoteProperty -name "Userprincipalname" -Value $upn
$info | add-member -membertype NoteProperty -name "Studentemail" -Value $studentemail
$info | add-member -membertype NoteProperty -name "GroupEmail" -Value $groupemail

# Save the current $contactObject by appending it to $resultsArray ( += means append a new element to ‘me’)
$Students += $info

Write-Progress -Activity "Variables" -Status "Percent Complete $j" -PercentComplete ($j)
}
#unmark the following line to see the output
$students| Export-csv -path "$env:userprofile\desktop\students.csv" -notypeinformation