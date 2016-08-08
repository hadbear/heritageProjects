Get-ADUser -Filter * -SearchBase "OU=students,OU=Mesa,DC=ha,DC=edu" | Disable-ADAccount
Get-ADUser -Filter * -SearchBase "OU=students,OU=Gateway,DC=ha,DC=edu" | Disable-ADAccount
Get-ADUser -Filter * -SearchBase "OU=Students,OU=Laveen,DC=ha,DC=edu" | Disable-ADAccount