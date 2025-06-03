function Get-ManualDates
{
    $manualDates = @()

    while ($true)
    {
        $dateInput = Read-Host "enter a date 'dd.MM.yyyy', if done please [done]"
        
        if ($dateInput -eq "done")
        {
            break
        }

        try
        {
            [datetime]::Parse($dateInput) | Out-Null
            $manualDates += $dateInput
            Write-Host "-> '$dateInput' was added"
        }
        
        catch
        {
            Write-Host "'$dateInput' is not a valid input, pls dd.MM.yyyy or [skip]"
        }
    }

    if ($manualDates.Count -gt 0)
    {
        $manualDates | Out-File ".\importedDates\manualInput.txt"
        Write-Host "`n'manualInput.txt' was created at '.\importedDates'"
    }
    
    else
    {
        Write-Host "no valid dates entered. no file created."
    }
}

function Get-TxtDates
{
    $validDates = @()

    if (Test-Path ".\importedDates\*.txt")
    {
        $datesInFileTxt = Get-Content ".\importedDates\*.txt"
        foreach ($line in $datesInFileTxt)
        {
            try
            {
                $parsed = [datetime]::Parse($line)
                $validDates += $parsed
            }
            
            catch
            {
                
            }
        }
    }
    
    else
    {
        Write-Host ".txt files not found. Skipping..."
    }

    return $validDates
}


function Get-CsvDates
{
    $validDates = @()

    if (Test-Path ".\importedDates\*.csv")
    {
        $datesInFileCsv = Import-Csv ".\importedDates\*.csv"
        foreach ($line in $datesInFileCsv)
        {
            if ($line.day -and $line.month -and $line.year)
            {
                $dateString = "$($line.day).$($line.month).$($line.year)"
                try {
                    $parsed = [datetime]::ParseExact($dateString, 'd.M.yyyy', $null)
                    $validDates += $parsed
                } catch {}
            }
        }
    } else
    {
        Write-Host ".csv files not found. Skipping..."
    }

    return $validDates
}

function Save-SortedDates
{
    param
    (
        [array]$dates
    )

    if (-not (Test-Path ".\sortedDates"))
    {
        New-Item -ItemType Directory -Path ".\sortedDates" | Out-Null
    }

    $sortedDates = $dates | Sort-Object
    $sortedDates | ForEach-Object { $_.ToString("dd.MM.yyyy") } | Out-File ".\sortedDates\sortedDates.csv"

    $uniqueDates = $dates | Select-Object -Unique | Sort-Object
    $uniqueDates | ForEach-Object { $_.ToString("dd.MM.yyyy") } | Out-File ".\sortedDates\uniqueSortedDates.csv"

    if (Test-Path ".\sortedDates\sortedDates.csv")
    {
        Write-Host "'sortedDates.csv' was created at '.\sortedDates'"
    }

    if (Test-Path ".\sortedDates\uniqueSortedDates.csv")
    {
        Write-Host "'uniqueSortedDates.csv' was created at '.\sortedDates'"
    }
}