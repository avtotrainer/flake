# kbdgemtv — ინსტალაცია: 1) სისტემური ნაწილი ადმინით, 2) განლაგება მიმდინარე მომხმარებელს
param([switch]$KeepOtherGeorgian)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Dll  = 'kbdgemtv.dll'

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$sysScript = Join-Path $here 'install-system.ps1'
# სისტემური ნაწილი უკვე დაყენებულია (იგივე DLL + რეესტრი)? მაშინ მოსწავლის ანგარიშს ადმინი არ სჭირდება.
$arch = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
$srcDll = Join-Path $here (@{ AMD64 = 'amd64'; ARM64 = 'arm64'; x86 = 'i386' }[$arch] + "\$Dll")
$sysDll = if ([Environment]::Is64BitProcess -or $arch -eq 'x86') { "$env:windir\System32\$Dll" } else { "$env:windir\Sysnative\$Dll" }
$registered = Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\*' | Where-Object { $_.'Layout File' -ieq $Dll }
$upToDate = $registered -and (Test-Path $sysDll) -and ((Get-FileHash $srcDll).Hash -eq (Get-FileHash $sysDll).Hash)
if ($upToDate) { Write-Host 'სისტემური ნაწილი უკვე დაყენებულია — ადმინი არ სჭირდება.' }
elseif ($isAdmin) { & $sysScript }
else {
    Write-Host 'ადმინისტრატორის უფლება საჭიროა DLL-ის დასაყენებლად — დაეთანხმეთ UAC ფანჯარას.'
    $p = Start-Process powershell -Verb RunAs -Wait -PassThru -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',"`"$sysScript`"")
    if ($p.ExitCode -ne 0) { throw 'სისტემური ინსტალაცია ვერ შესრულდა.' }
}

$klid = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\*' |
    Where-Object { $_.'Layout File' -ieq $Dll } | Select-Object -First 1).PSChildName
if (-not $klid) { throw 'განლაგება რეესტრში ვერ მოიძებნა.' }
$tip = "0437:$klid"

$list = Get-WinUserLanguageList
$ka = $list | Where-Object { $_.LanguageTag -like 'ka*' } | Select-Object -First 1
if (-not $ka) { $list.Add('ka-GE'); $ka = $list | Where-Object { $_.LanguageTag -like 'ka*' } | Select-Object -First 1 }
if (-not $KeepOtherGeorgian) { $ka.InputMethodTips.Clear() }
if ($ka.InputMethodTips -notcontains $tip) { $ka.InputMethodTips.Add($tip) }
Set-WinUserLanguageList $list -Force
Write-Host "დაემატა თქვენს ენებს: $tip"

# თვითშემოწმება: ჩაიტვირთება თუ არა განლაგება და რას წერს Q კლავიში
Add-Type -Namespace K -Name U -MemberDefinition @'
[DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern IntPtr LoadKeyboardLayout(string id, uint flags);
[DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int ToUnicodeEx(uint vk, uint sc, byte[] st, System.Text.StringBuilder b, int n, uint f, IntPtr hkl);
'@
$hkl = [K.U]::LoadKeyboardLayout($klid, 0)
function T($mods) { $s = New-Object byte[] 256; foreach ($m in $mods) { $s[$m[0]] = $m[1] }
    $b = New-Object System.Text.StringBuilder 8; [void][K.U]::ToUnicodeEx(0x51, 0x10, $s, $b, 8, 4, $hkl); $b.ToString() }
if ($hkl -eq [IntPtr]::Zero) { Write-Warning 'LoadKeyboardLayout ვერ ჩატვირთა — გადატვირთეთ კომპიუტერი და სცადეთ.' }
else {
    $r = @{ 'Q' = T @(); 'Shift+Q' = T @(,@(0x10,0x80)); 'CapsLock+Q' = T @(,@(0x14,0x01)); 'AltGr+Q' = T @(@(0x11,0x80),@(0x12,0x80)) }
    $r.GetEnumerator() | Sort-Object Name | ForEach-Object { Write-Host ("  {0,-11} -> {1}" -f $_.Name, $_.Value) }
    if ($r['Q'] -eq [string][char]0x10E9 -and $r['Shift+Q'] -eq [string][char]0x1CA9 -and $r['CapsLock+Q'] -eq [string][char]0x1CA9) {
        Write-Host 'შემოწმება: OK (ჩ / Ჩ / Ჩ)' -ForegroundColor Green
    } else { Write-Warning 'შემოწმების შედეგი მოსალოდნელს არ ემთხვევა.' }
}
Write-Host 'მზადაა. გადართვა: Win+Space. თუ სიაში არ ჩანს — გამოდით და ხელახლა შედით სისტემაში.'
