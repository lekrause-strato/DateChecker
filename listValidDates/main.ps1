. ".\listValidDates\funcions.ps1"

$userInput = Read-Host "do you want to manually enter dates? please [y] = yes , [n] = no"

if ($userInput -eq "y") {
    Get-ManualDates
} elseif ($userInput -eq "n") {
    Write-Host "Manual input skipped."
} else {
    Write-Host "invalid input, Manual input skipped."
}

Start-Sleep -Seconds 1.5
Write-Host "`nSorting available dates...`n"
Start-Sleep -Seconds 1

$allDates = @()
$allDates += Get-TxtDates
$allDates += Get-CsvDates

Save-SortedDates -dates $allDates