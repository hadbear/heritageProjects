#variables for manipulations
###
$a = ""
$b = "[^a-z]"
$l = "10" #name length
$c = "[[.*\]]"
$server = hostname
$y2 = "1"
$y = ""
$yy = ""
$ss = ""# to clear variable if ran twice
[int]$i = ""

##Clean Headers

$filename = 'C:\student.export.text'

(Get-Content $filename -Raw) -ireplace ("$c", "") |
  Set-Content $filename

##import user data
##
$Users = Import-Csv -Path "C:\student.export.text" -Delimiter ","

# Declare an array to collect our result objects
$Students =@()
#term calculations
#$yy = read-host -Prompt "What school year? Example 15-16 or 14-15"
#$ss = read-host -Prompt "Which Semester? 1 or 2?"
#$y = $yy.substring(0,2)
#if ($ss -eq "1"){
#$s = "Fall"
#$y = "20" + "$y"
#}
#if ($ss -eq "2"){
#$s ="Spring"
#$y = "20" + ([int]$y + [int]$y2)
#}
$ss = Get-date -UFormat "%m"
$y = Get-Date -UFormat "%Y"
if ($ss -lt "5"){
$s ="Spring"}
else {$s = "Fall"}
$year = "$s" + "$y"

$totalcount = $users | Measure-Object 
$totalcount = $totalcount.count

#$ErrorActionPreference= 'silentlycontinue'

ForEach ($user in $users){
$i++
$j = (($i / $totalcount) * 100)
$info = new-object PSObject
$Expression = $user."4Expression" -creplace("[()]","")

$location = $user."4SchoolID"



## Folder creation
if (($server -eq "haserver3") -and ($location -eq 3)){
#New-Item -ItemType directory -Path $teacherdirectory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#New-Item -ItemType directory -Path $Studentdirectory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#New-Item -ItemType symboliclink -Path $teacherdirectory -Name "$addisplayname" -Value $Studentdirectory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
## Create ad users        
New-ADUser -Name "$username" -DisplayName "$ADDisplayname" -SamAccountName $username -UserPrincipalName $upn -GivenName "$UserFirstname" -Surname "$UserLastname"  -EmailAddress "$studentemail" -Path $OUlocation -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true -HomeDirectory $ADhomefolder -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
New-ADGroup -DisplayName $ADgroupname -Name $ADgroupname -Path "OU=Class groups,DC=ha,DC=edu" -GroupCategory Security -GroupScope Global -SamAccountName $ADgroupname -OtherAttributes @{'mail'=$groupEmail} -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
Add-ADGroupMember -Identity $ADgroupname -Members "$username" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
Set-ADUser -Identity $username -HomeDirectory $adhomefolder -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
Set-ADUser -Identity $userteacher -HomeDirectory $teacherHomedirectory -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
Set-ADUser -Identity $username -UserPrincipalName $upn
Set-ADGroup -Identity $ADgroupname -ManagedBy $userteacher
}

# Folder creation
elseif (($server -eq "haserver2") -and ($location -eq 2)){
#New-Item -ItemType directory -Path $teacherdirectory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#New-Item -ItemType directory -Path $Studentdirectory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#New-Item -ItemType symboliclink -Path $teacherdirectory -Name "$addisplayname" -Value $Studentdirectory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
## Create ad users        
New-ADUser -Name "$username" -DisplayName "$ADDisplayname" -SamAccountName $username -UserPrincipalName $upn -GivenName "$UserFirstname" -Surname "$UserLastname"  -EmailAddress "$studentemail" -Path $OUlocation -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true -HomeDirectory $ADhomefolder -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
New-ADGroup -DisplayName $ADgroupname -Name $ADgroupname -Path "OU=Class groups,DC=ha,DC=edu" -GroupCategory Security -GroupScope Global -SamAccountName $ADgroupname -OtherAttributes @{'mail'=$groupEmail} -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
Add-ADGroupMember -Identity $ADgroupname -Members "$username" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
Set-ADUser -Identity $username -HomeDirectory $adhomefolder -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
Set-ADUser -Identity $userteacher -HomeDirectory $teacherHomedirectory -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
Set-ADUser -Identity $username -UserPrincipalName $upn
Set-ADGroup -Identity $ADgroupname -ManagedBy $userteacher
}

## Folder creation
elseif (($server -eq "haserver1") -and ($location -eq 1)){

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

#use the first 10 char and concatonate into sam for username
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

#New-Item -ItemType directory -Path $teacherdirectory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#New-Item -ItemType directory -Path $Studentdirectory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#New-Item -ItemType symboliclink -Path $teacherdirectory -Name "$addisplayname" -Value $Studentdirectory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
## Create ad users        
#New-ADUser -Name "$username" -DisplayName "$ADDisplayname" -SamAccountName $username -UserPrincipalName $upn -GivenName "$UserFirstname" -Surname "$UserLastname"  -EmailAddress "$studentemail" -Path $OUlocation -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true -HomeDirectory $ADhomefolder -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#New-ADGroup -DisplayName $ADgroupname -Name $ADgroupname -Path "OU=Class groups,DC=ha,DC=edu" -GroupCategory Security -GroupScope Global -SamAccountName $ADgroupname -OtherAttributes @{'mail'=$groupEmail} -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#Add-ADGroupMember -Identity $ADgroupname -Members "$username" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#Set-ADUser -Identity $username -HomeDirectory $adhomefolder -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#Set-ADUser -Identity $userteacher -HomeDirectory $teacherHomedirectory -HomeDrive "S:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |Out-Null
#Set-ADUser -Identity $username -UserPrincipalName $upn
Set-ADGroup -Identity $ADgroupname -ManagedBy $userteacher
}

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

Write-Progress -Activity "Creating users, groups, folders, and links" -Status "Percent Complete $j" -PercentComplete ($j)

}

#unmark the following line to see the output
$students| Export-csv -path c:\studentinfo.csv -notypeinformation