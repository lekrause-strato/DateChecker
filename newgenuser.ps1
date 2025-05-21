Import-Module ActiveDirectory
 

$todaysdate = Read-Host "use todays date? [y] = yes , [n] = no"
#while-Schleife: wenn vom Nutzer gewollt, wird das heutige Datum ausgewählt, sonst manuell eingeben
while($true){
    if($todaysdate -eq "y"){
        $date = (Get-Date).date
        break;
    }

    elseif($todaysdate -eq "n"){
        $date = Read-Host "set date(dd.MM.yyyy): "
        try{
            #wenn $datum schon ein datetimeobject ist dann einfach nur $datum.date (ist dann immernoch ein datetimeobject) --> weil [datetime]::ParseExact($Datum, 'dd.MM.yyyy', $null) einen string in ein datetimeobject umwandelt
            $date = [datetime]::ParseExact($date, 'dd.MM.yyyy', $null)  
            break
        }
        catch{
        $date = Read-Host "wrong format(dd.MM.yyyy, f.e. 24.12.2024): "
        }
    }
    
    else{
        $todaysdate = Read-Host "wrong input, please [y] = yes , [n] = no : "
    }
}

#alle Organizational Units, in denen gesucht werden soll
$OUs="OU=CC-Partner-Kosovo,OU=Domain Users,DC=intern,DC=nisi,DC=cc",
     "OU=CC-Partner-Abante,OU=Domain Users,DC=intern,DC=nisi,DC=cc",
     "OU=CC-Partner-Nordic,OU=Domain Users,DC=intern,DC=nisi,DC=cc",
     "OU=CC-Partner-Webhelp NL,OU=Domain Users,DC=intern,DC=nisi,DC=cc",
     "OU=CC-Partner-SinensisTech NL,OU=Domain Users,DC=intern,DC=nisi,DC=cc"

$userlist = @();
#alle User aus den OUs raussuchen, bei denen das eingegebene Datum gleich dem Datum des users ist
foreach($OU in $OUs){
    $userlist += Get-ADUser -Filter * -SearchBase $OU -Properties Name,surname, GivenName, created, EmailAddress, userprincipalname | Where-Object {($_.Created).Date -eq $date}
}


foreach($user in $userlist){
    #wenn kein Name vorhanden, wirf fehler
    if($null -eq ($user.Surname -or $user.Name)){
        Write-Host "missing name"
    }
    #wenn keine email vorhanden, erstelle email
    if($null -eq $user.EmailAddress){
        $user.EmailAddress = "$($user.GivenName).$($user.surname)@nisi.cc"     
    }
}
#Datum[datetime] in string umwandeln, damit Dateiname erstellt werden kann(. und - sind in Dateinamen verboten) und in derzeitiger Location als CSV-Datei abspeichern
$currentlocation = Get-Location
$formattedDate = $date.ToString("ddMMyyyy")
$userlist | select-Object -Property Name,  @{Name="E-mail";Expression={$_.EmailAddress}} | Export-CSV -Path $currentlocation\$formattedDate.csv -NoTypeInformation
