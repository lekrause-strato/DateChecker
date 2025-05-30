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
    Write-Host "'sortedDates.csv' was created"
} 
else
{
    Write-Host "'sortedDates.csv' could not be created"
}

if (Test-Path ".\sortedDates\uniqueSortedDates.csv")
{
    Write-Host "'uniqueSortedDates.csv' was created"
} 
else
{
    Write-Host "'uniqueSortedDates.csv' could not be created"
}