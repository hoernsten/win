Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\*" -Recurse -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\AppData\Local\Temp\*" -Recurse -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Recent\*" -Recurse -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"-ErrorAction SilentlyContinue

Write-EventLog –LogName Application –Source “Script” –EntryType Information –EventID 0 –Message (

    "Ran custom script.`n",
    "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "File: $($MyInvocation.MyCommand.Name)",
    "Path: $(Split-Path $MyInvocation.MyCommand.Definition)" | Out-String
)