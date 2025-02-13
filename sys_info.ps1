# IT Support System Info Script
# This script gathers essential system information for troubleshooting

# Function to gather basic system info
function Get-SystemInfo {
    Write-Host "`nCollecting system information..."
    $sysInfo = Get-ComputerInfo | Select-Object CsName, OsName, OsArchitecture, WindowsVersion, WindowsBuildLabEx
    $sysInfo
}

# Function to get hardware information
function Get-HardwareInfo {
    Write-Host "`nFetching hardware details..."
    $cpu = Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, MaxClockSpeed
    $ram = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | Select-Object Sum
    $disk = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID, Size, FreeSpace
    @{CPU = $cpu; RAM_MB = $ram.Sum / 1MB; Disk = $disk}
}

# Function to get network information
function Get-NetworkInfo {
    Write-Host "`nRetrieving network details..."
    $netInfo = Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress, AddressFamily
    $netInfo
}

# Function to get active processes
function Get-ActiveProcesses {
    Write-Host "`nListing active processes..."
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, Id
}

# Function to write system info to a file
function Save-Report {
    $filePath = "$env:USERPROFILE\Desktop\SystemReport.txt"
    Write-Host "`nSaving system report to: $filePath"
    Get-SystemInfo | Out-File -Append $filePath
    Get-HardwareInfo | Out-File -Append $filePath
    Get-NetworkInfo | Out-File -Append $filePath
    Get-ActiveProcesses | Out-File -Append $filePath
    Write-Host "Report saved successfully!"
}

# Interactive menu
while ($true) {
    Clear-Host
    Write-Host "=== IT Support System Info Script ===" -ForegroundColor Cyan
    Write-Host "1. Get System Info"
    Write-Host "2. Get Hardware Info"
    Write-Host "3. Get Network Info"
    Write-Host "4. Get Active Processes"
    Write-Host "5. Save Full Report"
    Write-Host "6. Exit"
    $choice = Read-Host "Select an option (1-6)"

    switch ($choice) {
        "1" { Get-SystemInfo | Format-Table -AutoSize; Pause }
        "2" { Get-HardwareInfo | Format-List; Pause }
        "3" { Get-NetworkInfo | Format-Table -AutoSize; Pause }
        "4" { Get-ActiveProcesses | Format-Table -AutoSize; Pause }
        "5" { Save-Report; Pause }
        "6" { break }
        default { Write-Host "Invalid choice, try again." -ForegroundColor Red; Pause }
    }
}
