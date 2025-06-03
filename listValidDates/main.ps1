. ".\listValidDates\funcions.ps1"

while ($true)
{
    $userInput = Read-Host "`nselect any action: add manual input = [1] , sort dates = [2] , delete dates = [3] , exit = [4]"

    if ($userInput -eq "1") {
        Get-ManualDates
    }
    elseif ($userInput -eq "2")
    {
        Write-Host "`nsorting available dates...`n" -ForegroundColor DarkMagenta
        $allDates = @()
        $allDates += Get-TxtDates
        $allDates += Get-CsvDates
        Save-SortedDates -dates $allDates
    }
    elseif ($userInput -eq "3")
    {
        Remove-Dates
    }

    elseif ($userInput -eq "4")
    {
        Write-Host "exiting script..." -ForegroundColor Blue
        break
    }
    else
    {
        Write-Host "invalid entry, please [1-4]`n" -ForegroundColor Blue
    }
}