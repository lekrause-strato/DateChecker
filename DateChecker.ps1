$todaysdate = Read-Host "use todays date? [y] = yes , [n] = no"
while($true){
    if($todaysdate -eq "y"){
        $date = (Get-Date).date
        break;
    }

    elseif($todaysdate -eq "n"){
        $date = Read-Host "set date(dd.MM.yyyy): "
        try{
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