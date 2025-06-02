$userInput = Read-Host "do you want to manually enter dates? please [y] = yes , [n] = no"

if ($userInput -eq "y")
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

elseif($userInput -eq "n")
{  
    Write-Host "manual input skipped"
}

else
{
    Write-Host "wrong input, manual input skipped"
}

Start-Sleep -Seconds 2

Write-Host "`nsorting avaliable dates...`n"

Start-Sleep -Seconds 2.5

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
    Write-Host ".txt file not found, skipping..."
}

if (Test-Path ".\importedDates\*.csv")
{
    $datesInFileCsv = Import-Csv ".\importedDates\*.csv"
    foreach ($line in $datesInFileCsv)
    {
        if ($line.day -and $line.month -and $line.year)
        {
            $dateString = "$($line.day).$($line.month).$($line.year)"
            try
            {
                $parsed = [datetime]::ParseExact($dateString, 'd.M.yyyy', $null)
                $validDates += $parsed
            }
            catch
            {

            }
        }
    }
}

else 
{
    Write-Host ".csv file not found, skipping..."
}

$sortedDates = $validDates | Sort-Object
$sortedDates | ForEach-Object { $_.ToString("dd.MM.yyyy") } | Out-File ".\sortedDates\sortedDates.csv"

$uniqueDates = $validDates | Select-Object -Unique
$sortedDates = $uniqueDates | Sort-Object
$sortedDates | ForEach-Object { $_.ToString("dd.MM.yyyy") } | Out-File ".\sortedDates\uniqueSortedDates.csv"

if (Test-Path ".\sortedDates\sortedDates.csv")
{
    Write-Host "'sortedDates.csv' was created at '.\sortedDates'"
}

if (Test-Path ".\sortedDates\uniqueSortedDates.csv")
{
    Write-Host "'uniqueSortedDates.csv' was created at '.\sortedDates'"
}