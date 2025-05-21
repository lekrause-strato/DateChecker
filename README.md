listValidDates.ps1

Description:
--This PowerShell script reads, filters, validates, and sorts date entries from .txt and .csv files. It supports mixed input formats and outputs both sorted and unique sorted dates into separate folders.

How it works:
-- The script reads all .txt and .csv files from the 'importedDates' folder.
-- It validates each date entry and ignores invalid or malformed dates.

Valid dates are:
-- Parsed using PowerShell's [datetime] parser
-- Sorted chronologically
-- De-duplicated using Select-Object -Unique
-- Results are saved in the sortedDates folder.

Input Format:

1. .txt files
Each line must contain a date in a recognizable format, e.g.:
Kopieren
Bearbeiten
31.08.1999
01-01-2020
2022-06-30

2. .csv files
Each row must contain the columns: day, month, and year. Example:
day,month,year
31,08,1999
1,1,2020

Important: Only .txt and .csv files are supported. Any other file type will be ignored.

Output:
-- The script generates two output files in the sortedDates folder:
-- sortedDates.csv: All valid dates, sorted.
-- uniqueSortedDates.csv: Only unique valid dates, sorted.

Notes:
-- The script does not create folders. Make sure the importedDates and sortedDates folders exist before running the script.
-- Error handling is included to skip invalid lines or missing values silently.
-- This README file was created by ChatGPT, because I'm way too lazy for that.
