# კლავიატურის განლაგება — წაშლა: მომხმარებლის სიიდან, რეესტრიდან და სისტემიდან
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$L    = Import-PowerShellDataFile (Join-Path $here 'layout.psd1')   # build.sh-ის მიერ: Dll, Text, Tests
$Dll  = $L.Dll
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$root = 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts'
$klid = (Get-ItemProperty "$root\*" | Where-Object { $_.'Layout File' -ieq $Dll } | Select-Object -First 1).PSChildName

if ($klid -and -not $isAdmin) {
    $list = Get-WinUserLanguageList
    foreach ($l in $list) { [void]$l.InputMethodTips.Remove("0437:$klid") }
    $ka = $list | Where-Object { $_.LanguageTag -like 'ka*' }
    if ($ka -and $ka.InputMethodTips.Count -eq 0) { $ka.InputMethodTips.Add('0437:00000437') }   # Windows-ის ჩაშენებული ქართული განლაგება
    Set-WinUserLanguageList $list -Force
    Write-Host "მოიხსნა თქვენი სიიდან: 0437:$klid"
    Start-Process powershell -Verb RunAs -Wait -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',"`"$($MyInvocation.MyCommand.Path)`"")
    return
}
if ($klid) { Remove-Item "$root\$klid" -Recurse -Force; Write-Host "რეესტრიდან წაიშალა: $klid" }
foreach ($d in "$env:windir\System32", "$env:windir\Sysnative", "$env:windir\SysWOW64") {
    $f = Join-Path $d $Dll
    if (Test-Path $f) {
        try { Remove-Item $f -Force; Write-Host "წაიშალა: $f" }
        catch { Write-Warning "$f გამოყენებაშია — გადატვირთვის შემდეგ uninstall.cmd ხელახლა გაუშვით." }
    }
}
Start-Sleep 3
