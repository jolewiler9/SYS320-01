# Start Calculator
Start-Process -FilePath "C:\Windows\system32\win32calc"

# Wait for a few seconds
Start-Sleep -Seconds 5

# Stop Calculator
$calculatorProcess = Get-Process -Name "win32calc"

if ($calculatorProcess) {
    Stop-Process -Id $calculatorProcess.Id
}