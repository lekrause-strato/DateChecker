$todaysdate = Read-Host "use todays date? [y] = yes , [n] = no"
$retryDateInput = $true

while($true)
{
    if($todaysdate -eq "y")
    {
        $date = (Get-Date).date
        break
    }
    elseif ($todaysdate -eq "n")
    {
        if ($retryDateInput)
        {
            $date = Read-Host "set date(dd.MM.yyyy)"
        }
        try
        {
            $date = [datetime]::ParseExact($date, 'dd.MM.yyyy', $null)  
            break
        }
        catch
        {
            $date = Read-Host "wrong format(dd.MM.yyyy, f.e. 24.12.2024)"
            $retryDateInput = $false
        } 
    }
    else
    {
        $todaysdate = Read-Host "wrong input, please [y] = yes , [n] = no"
    }
}

Write-Host "Your date is $($date.ToString('dd.MM.yyyy'))."