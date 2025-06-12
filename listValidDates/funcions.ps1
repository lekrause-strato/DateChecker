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
            Write-Host "-> '$dateInput' was added" -ForegroundColor Green
        }
        
        catch
        {
            if ($dateInput -ne "")
            {
                Write-Host "'$dateInput' is not a valid input" -ForegroundColor Red
            }
            elseif ($dateInput -eq "")
            {
                Write-Host "'NULL' is not a valid input" -ForegroundColor Red
            } 
        }
    }

    if ($manualDates.Count -gt 0)
    {
        $manualDates | Out-File ".\importedDates\manualInput.txt"
        Write-Host "`n'manualInput.txt' was created at '.\importedDates'" -ForegroundColor Cyan
    }
    
    else
    {
        Write-Host "no valid dates entered. no file created" -ForegroundColor Blue
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
        Write-Host ".txt files not found. Skipping..." -ForegroundColor Blue
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
        Write-Host ".csv files not found. Skipping..." -ForegroundColor Blue
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
        Write-Host "'sortedDates.csv' was created at '.\sortedDates'" -ForegroundColor Cyan
    }

    if (Test-Path ".\sortedDates\uniqueSortedDates.csv")
    {
        Write-Host "'uniqueSortedDates.csv' was created at '.\sortedDates'" -ForegroundColor Cyan
    }
}
function Move-DateToDeleted
{
    param
    (
        [string]$datesFile = ".\sortedDates\sortedDates.csv",
        [string]$deletedFile = ".\deletedDates\deletedDates.csv"
    )

    $dates = Get-Content $datesFile

    $dateToDelete = Read-Host "enter a date to move, please 'dd.MM.yyyy'"

    if ($dates -contains $dateToDelete)
    {
        $dates | Where-Object { $_ -ne $dateToDelete } | Set-Content $datesFile
        Add-Content $deletedFile $dateToDelete

        Write-Host "Date $dateToDelete has been moved to .\deletedDates.csv" -ForegroundColor Cyan
    }
    elseif ($dateToDelete)
    {
        Write-Host "'$dateToDelete' is not a valid input, please 'dd.MM.yyyy'" -ForegroundColor Red
    }
    else
    {
        Write-Host "no valid date entered. no file created" -ForegroundColor Blue
    }
}