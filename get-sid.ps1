Param(

  [string]$User,
  [string]$SID
)

if ($User) {

    try {

        $objUser = New-Object System.Security.Principal.NTAccount("example.com", "$User")
        $traSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
    }

    catch [System.Management.Automation.MethodException] {

        Write-Host -ForegroundColor Red "ERROR: Invalid User ID"; Exit
    }

    Write-Host "User:" $User
    Write-Host "SID:" $traSID `n
}

if ($SID) {

    try {

        $objSID = New-Object System.Security.Principal.SecurityIdentifier("$SID")
        $traUser = $objSID.Translate( [System.Security.Principal.NTAccount])
    }

    catch [System.Management.Automation.MethodException] {
    
        Write-Host -ForegroundColor Red "ERROR: Invalid SID"; Exit
    }

    Write-Host "User:" $traUser
    Write-Host "SID:" $SID `n
}

if (!$User -and !$SID) {

    Write-Host "Usage:" `n ".\script -User nobody" `n ".\script -SID S-1-0-0"
}
