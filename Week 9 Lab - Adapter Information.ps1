$networkAdapters = Get-WmiObject -Class "Win32_NetworkAdapterConfiguration"

foreach ($adapter in $networkAdapters) {
Write-Host "Network Adapter: $($adapter.Description)"
Write-Host "DNS Server(s): $($adapter.DNSServerSearchOrder)"
Write-Host "DHCP Server(s): $($adapter.DHCPServer)"
}