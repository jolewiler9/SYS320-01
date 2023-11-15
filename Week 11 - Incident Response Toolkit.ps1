# Function to get file hash
function Get-FileHashAndWriteToFile($filePath, $outputFile) {
    $hash = Get-FileHash -Algorithm SHA1 -Path $filePath | Select-Object -ExpandProperty Hash
    "$hash  $outputFile" | Out-File -Append -FilePath "$resultsLocation\checksums.txt"
}

# Prompt user for the location to save results
$resultsLocation = Read-Host "Enter the location to save results"

# Create directory if it doesn't exist
if (-not (Test-Path $resultsLocation -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $resultsLocation
}

# Task 1: Get running processes and their paths
$processes = Get-Process | Select-Object Name, Path
$processes | Export-Csv -Path "$resultsLocation\processes.csv" -Force -NoTypeInformation
Get-FileHashAndWriteToFile "$resultsLocation\processes.csv" "processes.csv"

# Task 2: Get registered services and paths to their executables using WMI
$services = Get-WmiObject -Query "SELECT * FROM Win32_Service" | Select-Object Name, PathName
$services | Export-Csv -Path "$resultsLocation\services.csv" -Force -NoTypeInformation
Get-FileHashAndWriteToFile "$resultsLocation\services.csv" "services.csv"

# Task 3: Get all TCP network sockets
$tcpSockets = Get-NetTCPConnection
$tcpSockets | Export-Csv -Path "$resultsLocation\tcpSockets.csv" -Force -NoTypeInformation
Get-FileHashAndWriteToFile "$resultsLocation\tcpSockets.csv" "tcpSockets.csv"

# Task 4: Get all user account information using WMI
$userAccounts = Get-WmiObject -Query "SELECT * FROM Win32_UserAccount" | Select-Object Name, FullName, Status
$userAccounts | Export-Csv -Path "$resultsLocation\userAccounts.csv" -Force -NoTypeInformation
Get-FileHashAndWriteToFile "$resultsLocation\userAccounts.csv" "userAccounts.csv"

# Task 5: Get NetworkAdapterConfiguration information
$networkConfig = Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object Description, IPAddress, MACAddress
$networkConfig | Export-Csv -Path "$resultsLocation\networkAdapterConfiguration.csv" -Force -NoTypeInformation
Get-FileHashAndWriteToFile "$resultsLocation\networkAdapterConfiguration.csv" "networkAdapterConfiguration.csv"

# Task 6: Use PowerShell cmdlets to save 4 other artifacts (customize as needed)
# Example: Get event logs, system information, installed programs, and running services
# This command grabs the event logs of the system, which is useful for seeing possible malicious intent in whats being done on the system
Get-EventLog -LogName System -After (Get-Date).AddDays(-7) | Export-Csv -Path "$resultsLocation\eventLogs.csv" -Force -NoTypeInformation

# This command grabs the currently logged in users, allowing you to see if there are any users that aren't validated or expected to be logged into the system
Get-WmiObject -Class Win32_ComputerSystem | Select-Object UserName | Export-Csv -Path "$resultsLocation\loggedUsers.csv" -Force -NoTypeInformation

# This shows all installed programs, running or not allowing you to know exactly what is installed on a system, which is useful for something like incident response
# and seeing what all could be affecting a system
Get-WmiObject Win32_Product | Select-Object Name, Version | Export-Csv -Path "$resultsLocation\installedPrograms.csv" -Force -NoTypeInformation

# This cmdlet lets you see all RUNNING services on a the system, which can let you monitor for possible anomolies and services that
# shouldn't be running on the system
Get-Service | Where-Object { $_.Status -eq 'Running' } | Select-Object DisplayName, ServiceName | Export-Csv -Path "$resultsLocation\runningServices.csv" -Force -NoTypeInformation

# Get file hashes for the additional artifacts
Get-FileHashAndWriteToFile "$resultsLocation\eventLogs.csv" "eventLogs.csv"
Get-FileHashAndWriteToFile "$resultsLocation\loggedUsers.csv" "loggedUsers.csv"
Get-FileHashAndWriteToFile "$resultsLocation\installedPrograms.csv" "installedPrograms.csv"
Get-FileHashAndWriteToFile "$resultsLocation\runningServices.csv" "runningServices.csv"

# Prompt user for the location to save results
$zipLocation = Read-Host "Enter the location to save the zip file"

# Create your own option with expected results (customize as needed)
# Example: Create a text file with a custom message
$customMessage = "This is a custom message."
$customMessage | Out-File -FilePath "$resultsLocation\customMessage.txt" -Force
Get-FileHashAndWriteToFile "$resultsLocation\customMessage.txt" "customMessage.txt"

# Create a checksum file for the zip file
Compress-Archive -Path $resultsLocation -DestinationPath "$zipLocation\results.zip" -Force
Get-FileHashAndWriteToFile "$zipLocation\results.zip" "results.zip"

# Record the screen (manual step)
Write-Host "Please record the screen to verify the results."

Write-Host "Script execution complete."
