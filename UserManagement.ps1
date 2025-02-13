# IT Support - User Account Management Script

function Show-Menu {
    Clear-Host
    Write-Host "=== User Account Management ===" -ForegroundColor Cyan
    Write-Host "1. Create New User"
    Write-Host "2. Disable User Account"
    Write-Host "3. Enable User Account"
    Write-Host "4. Remove User Account"
    Write-Host "5. Exit"
    $choice = Read-Host "Select an option (1-5)"
    return $choice
}

function Create-User {
    $username = Read-Host "Enter new username"
    $fullname = Read-Host "Enter full name"
    $password = -join ((33..126) | Get-Random -Count 12 | ForEach-Object {[char]$_}) # Generate random password

    New-LocalUser -Name $username -FullName $fullname -Password (ConvertTo-SecureString $password -AsPlainText -Force) -AccountNeverExpires
    Write-Host "User '$username' created successfully!" -ForegroundColor Green
    Write-Host "Temporary Password: $password" -ForegroundColor Yellow
}

function Disable-User {
    $username = Read-Host "Enter username to disable"
    Disable-LocalUser -Name $username
    Write-Host "User '$username' has been disabled." -ForegroundColor Yellow
}

function Enable-User {
    $username = Read-Host "Enter username to enable"
    Enable-LocalUser -Name $username
    Write-Host "User '$username' has been enabled." -ForegroundColor Green
}

function Remove-User {
    $username = Read-Host "Enter username to remove"
    Remove-LocalUser -Name $username -Confirm:$false
    Write-Host "User '$username' has been removed." -ForegroundColor Red
}

while ($true) {
    $choice = Show-Menu
    switch ($choice) {
        "1" { Create-User; Pause }
        "2" { Disable-User; Pause }
        "3" { Enable-User; Pause }
        "4" { Remove-User; Pause }
        "5" { break }
        default { Write-Host "Invalid option. Try again." -ForegroundColor Red; Pause }
    }
}
