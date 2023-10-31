# Storyline: Using the services and processes commands
Get-Process | Select-Object ProcessName, Path, ID | `
Export-Csv -Path "C:\users\champuser\Desktop\myProcesses.csv"

Get-Service | Where { $_.Status -eq "Running" } | select ProcessName, ID, Path | `
Export-Csv -Path "C:\users\champuser\Desktop\myServices.csv"