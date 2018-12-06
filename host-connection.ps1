[System.Collections.ArrayList]$array = @()

do {

    # Allow for multiple hosts to be added to the array
    $input = Read-Host "Add host"

    if ($input -ne '') {

        $array += $input
    }
} 

# Continue once a blank value has been supplied to the array
until ($input -eq '')

function Host-Connection {

    try {

        # Perform a connection check for each host in the array
        foreach ($i in $array) {

            $time = Get-Date -Format HH:mm:ss
            $ping = Test-Connection -Count 1 -ComputerName $i -Quiet

            if (!$ping) {

                # Note that the host is offline and move on
                Write-Host "$time`: Host $i is offline"
            }

            elseif ($ping) {

                # Create a VBS script used for generating popups
                Write-Output "Set objArgs = WScript.Arguments" >> $env:TEMP\popup.vbs
                Write-Output "messageText = objArgs(0)" >> $env:TEMP\popup.vbs
                Write-Output "messageTitle = objArgs(1)" >> $env:TEMP\popup.vbs
                Write-Output "x=msgbox(messageText,0,messageTitle)" >> $env:TEMP\popup.vbs

                # Play the Imperial March once a host comes online, run the popup VBS script and remove the host from the array
                Write-Host "$time`: Host $i is online" -ForegroundColor Green

                [console]::beep(440,500)       
                [console]::beep(440,500) 
                [console]::beep(440,500)        
                [console]::beep(349,350)        
                [console]::beep(523,150)        
                [console]::beep(440,500)        
                [console]::beep(349,350)        
                [console]::beep(523,150)        
                [console]::beep(440,950)

                cscript $env:TEMP\popup.vbs "Host $i is online ($time)" "$i" | Out-Null
                Remove-Item $env:TEMP\popup.vbs
                $array.Remove($i)
            }
        }

        # Set the time interval between connection checks
        Start-Sleep -Seconds 60
    }

    # Disregard any errors about hosts being removed from the array
    catch [System.InvalidOperationException] {}
}

# Continue to loop through the function as long as there are hosts in the array
while ($array -ne '') {

    Host-Connection
}

[void](Read-Host 'Press Enter to exit…')
