# Storyline: Review the Security Event Log

# Directory for Event Log to be stored
$myDir = "C:\Users\champuser\Desktop\"

# List all available Event Logs
Get-EventLog -list

# Create a prompt for the user to both select a log to view and filter strings from that log 
$readLog = Read-host -Prompt "Please select a log to review from the list above"
$searchString = Read-Host -Prompt "Please enter search string to be filtered"

# Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$searchString*"} | export-csv -NoTypeInformation `
-Path "$myDir\securityLogs.csv"