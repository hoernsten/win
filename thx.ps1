# Check if the AudioDeviceCmdlets module is installed
if (-Not (Get-Command Get-AudioDevice -ErrorAction SilentlyContinue)) {

    # Download and import the AudioDeviceCmdlets module
    Write-Host "Importing AudioDeviceCmdlets..."
    Set-Location $env:USERPROFILE\Downloads
    Invoke-WebRequest -URI https://github.com/frgnca/AudioDeviceCmdlets/releases/download/v3.0/AudioDeviceCmdlets.dll -OutFile AudioDeviceCmdlets.dll

    # Verify the file hash before importing
    if ((Get-FileHash AudioDeviceCmdlets.dll).Hash -eq "7DD88E4467A2455313AA15DA755B88EBD1F9A8F456301AEA8D369514FD9A5E64") {

        New-Item "$($profile | Split-Path)\Modules\AudioDeviceCmdlets" -Type Directory -Force
        Copy-Item AudioDeviceCmdlets.dll "$($profile | Split-Path)\Modules\AudioDeviceCmdlets\AudioDeviceCmdlets.dll"
        Set-Location "$($profile | Split-Path)\Modules\AudioDeviceCmdlets"
        Get-ChildItem | Unblock-File
        Import-Module AudioDeviceCmdlets
        Remove-Item $env:USERPROFILE\Downloads\AudioDeviceCmdlets.dll
    }

    else {

        Remove-Item AudioDeviceCmdlets.dll
        Write-Host "Error: File hash does not match!" -ForegroundColor Red
        Write-Host "Press Enter to quit..."
        Read-Host
        Exit
    }
}

# Switch playback device
try {

    Set-AudioDevice -ID $((Get-AudioDevice -List | Where-Object {$_.Name -eq "Högtalare (Razer Kraken TE - Game)"}).ID) 1> $null
}

catch [System.ArgumentException] {

    Write-Host "Error: No playback device named 'Högtalare (Razer Kraken TE - Game)' found" -ForegroundColor Red
}


# Stop the THX service
Write-Host "Stopping the THX service..."
Stop-Service THXService -ErrorAction SilentlyContinue

# Stop the THX Helper processes
Get-Process -ProcessName THXHelper* | foreach {

    Write-Host "Restarting the" $_.Name "process..."
    Stop-Process -Name $_.Name
}

Sleep 2

# Start the THX Helper processes
Get-ChildItem -Recurse 'C:\Program Files (x86)\Razer\' -File THXHelper*.exe | foreach {

    Start-Process -FilePath $_.FullName
}

# Start the THX service
Write-Host "Starting the THX service..."
Start-Service THXService -ErrorAction SilentlyContinue

Sleep 2

# Switch back to previous playback device
try {

    Set-AudioDevice -ID $((Get-AudioDevice -List | Where-Object {$_.Name -eq "Högtalare (THX Spatial - Synapse)"}).ID) 1> $null
}

catch [System.ArgumentException] {

    Write-Host "Error: No playback device named 'Högtalare (THX Spatial - Synapse)' found" -ForegroundColor Red
}

# Create an event log
Write-EventLog –LogName Application –Source “Script” –EntryType Information –EventID 0 –Message (

    "Ran custom script.`n",
    "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "File: $($MyInvocation.MyCommand.Name)",
    "Path: $(Split-Path $MyInvocation.MyCommand.Definition)" | Out-String
)