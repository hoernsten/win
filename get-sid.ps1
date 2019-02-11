$domain = "example.com"
$object = $args[0]

try {
    
    if ($object -match 'S\-.*') {
        
        $sid = New-Object System.Security.Principal.SecurityIdentifier("$object")
        $user = $sid.Translate([System.Security.Principal.NTAccount])
    }

    else {

        $user = New-Object System.Security.Principal.NTAccount("$domain", "$object")
        $sid = $user.Translate([System.Security.Principal.SecurityIdentifier])
    }
}

catch [System.Management.Automation.MethodException] {

    Write-Host -ForegroundColor Red "Error: $($object) not found in $($domain)"
    Exit
}

Write-Host `n"User:" $user
Write-Host "SID:" $sid
Write-Host "Domain:" $domain`n
