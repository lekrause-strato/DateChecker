$validDates = @()

if (Test-Path "*.txt")
{
    $datesInFileTxt = Get-Content "*.txt"
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

if (Test-Path "*.csv")
{
    $datesInFileCsv = Import-Csv "*.csv"
    foreach ($line in $datesInFileCsv)
    {
        if ($line.tag -and $line.monat -and $line.jahr)
        {
            $dateString = "$($line.tag).$($line.monat).$($line.jahr)"
            try
            {
                $parsed = [datetime]::ParseExact($dateString, 'd.M.yyyy', $null)
                $validDates += $parsed
            }
            catch { }
        }
    }
}
else 
{
    Write-Host ".csv file not found, skipping..."
}

$sortedDates = $validDates | Sort-Object
$sortedDates | ForEach-Object { $_.ToString("dd-MM-yyyy") }