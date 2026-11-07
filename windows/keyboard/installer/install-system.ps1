# kbdgemtv — სისტემური ინსტალაცია (ადმინისტრატორის უფლებით): DLL-ები + რეესტრი
$ErrorActionPreference = 'Stop'
trap { Write-Host $_ -ForegroundColor Red; Read-Host 'შეცდომა. დააჭირეთ Enter-ს'; exit 1 }
$Dll  = 'kbdgemtv.dll'
$Text = 'Georgian (Ergonomic, Mtavruli) - avto'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Get-ChildItem -Recurse $here | Unblock-File -ErrorAction SilentlyContinue

$arch = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
$sys32 = if ([Environment]::Is64BitProcess -or $arch -eq 'x86') { "$env:windir\System32" } else { "$env:windir\Sysnative" }
$plan = switch ($arch) {
    'AMD64' { @(@('amd64', $sys32), @('wow64', "$env:windir\SysWOW64")) }
    'ARM64' { @(@('arm64', $sys32), @('wow64', "$env:windir\SysWOW64")) }
    'x86'   { @(,@('i386', $sys32)) }
    default { throw "უცნობი არქიტექტურა: $arch" }
}

foreach ($p in $plan) {
    $src = Join-Path $here "$($p[0])\$Dll"
    $dst = Join-Path $p[1] $Dll
    if (-not (Test-Path $p[1])) { continue }
    if ((Test-Path $dst) -and ((Get-FileHash $src).Hash -eq (Get-FileHash $dst).Hash)) {
        Write-Host "უკვე დაყენებულია: $dst"; continue
    }
    try { Copy-Item $src $dst -Force; Write-Host "დაკოპირდა: $dst" }
    catch { throw "$dst ვერ ჩაიწერა (ალბათ ძველი ვერსია გამოიყენება). გაუშვით uninstall.cmd, გადატვირთეთ კომპიუტერი და თავიდან სცადეთ." }
}

$root = 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts'
$all  = Get-ChildItem $root | ForEach-Object { [pscustomobject]@{ KLID = $_.PSChildName; P = Get-ItemProperty $_.PSPath } }
$mine = $all | Where-Object { $_.P.'Layout File' -ieq $Dll } | Select-Object -First 1
if ($mine) {
    $klid = $mine.KLID
} else {
    $used = $all.KLID
    $klid = 1..255 | ForEach-Object { 'a0{0:x2}0437' -f $_ } | Where-Object { $used -notcontains $_ } | Select-Object -First 1
    $ids  = $all | ForEach-Object { $_.P.'Layout Id' } | Where-Object { $_ } | ForEach-Object { [Convert]::ToInt32($_, 16) }
    $maxId = [int](($ids | Measure-Object -Maximum).Maximum)   # Measure-Object აბრუნებს double-ს — x4 ფორმატს int სჭირდება
    $layoutId = '{0:x4}' -f ($maxId + 1)
    $key = New-Item -Path "$root\$klid" -Force
    New-ItemProperty $key.PSPath 'Layout Id' -Value $layoutId -PropertyType String -Force | Out-Null
}
$k = "$root\$klid"
New-ItemProperty $k 'Layout File' -Value $Dll -PropertyType String -Force | Out-Null
New-ItemProperty $k 'Layout Text' -Value $Text -PropertyType String -Force | Out-Null
New-ItemProperty $k 'Layout Display Name' -Value "@%SystemRoot%\system32\$Dll,-1000" -PropertyType ExpandString -Force | Out-Null
Write-Host "რეესტრში დარეგისტრირდა: $klid"
Set-Content -Path (Join-Path $env:ProgramData 'kbdgemtv.klid') -Value $klid
