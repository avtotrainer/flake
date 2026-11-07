# windows/keyboard — ge-custom განლაგება Windows-ისთვის (kbdgemtv.dll)

NixOS-ის `modules/nixos/xkb/symbols/ge-custom` (ერგონომიკული ქართული, Caps Lock/Shift → მთავრული) Windows-ის keyboard layout DLL-ად.
ინსტალაციის ჰენდაუტი: [`docs/windows/keyboard-install.md`](../../docs/windows/keyboard-install.md).

---

## 1. გადაწყვეტილების კლასიფიკაცია

- ფენა: **არც System, არც User** — ეს NixOS-ის კონფიგურაცია არ არის, ამიტომ `modules/`-ში და `home/`-ში არ დევს. ცალკე დირექტორიაა `windows/`, flake-ის evaluation-ში არ მონაწილეობს.
- წყარო: **ერთადერთი** — `ge-custom`. Windows-ის ფაილები მისგან გენერირდება; `kbdgemtv.klc` და DLL-ები ხელით არ იცვლება.
- აგება: clang + lld-link (cross-compile Linux-ზე). MSKLC და Windows არ სჭირდება; ARM64 DLL-საც აგებს, რასაც MSKLC ვერ აკეთებს.

---

## 2. ფაილები

| ფაილი | რა არის | რედაქტირდება? |
|---|---|---|
| `build.sh` | მთელი ციკლი: xkb → klc → C ცხრილები → 4 DLL → შემოწმება → zip | `VERSION` |
| `src/ergonomic.xkb` | xkeyboard-config-ის `ge(ergonomic)` სექცია, რომელსაც `ge-custom` `include`-ით იყენებს (ზედა რიგი, `«»`) | იშვიათად |
| `src/kbdgemtv.c` | kbd.h-თავსებადი სტრუქტურები, scan code → VK ცხრილი, `KbdLayerDescriptor` | იშვიათად |
| `src/kbdgemtv.rc` | ვერსიის რესურსი + სტრიქონი 1000 (`Layout Display Name`) | `VERSION`-თან ერთად |
| `tools/xkb2klc.py` | `ergonomic.xkb` + `ge-custom` → `kbdgemtv.klc` | — |
| `tools/klc2c.py` | `kbdgemtv.klc` → `build/kbdgemtv_tables.inc` | — |
| `tools/verify_kbd.py` | აგებული DLL-დან კითხულობს KBDTABLES-ს და ადარებს `.klc`-ს | — |
| `kbdgemtv.klc` | გენერირებული; MSKLC-შიც იხსნება | **არა** (build.sh წერს) |
| `installer/` | `install.cmd/.ps1`, `install-system.ps1`, `uninstall.cmd/.ps1` | — |
| `build/`, `dist/` | აგების შედეგი, `.gitignore`-შია | — |

DLL-ის ვარიანტები: `amd64` (x64), `i386` (32-ბიტიანი Windows), `arm64`, `wow64` (32-ბიტიანი კოდი 64-ბიტიანი პოინტერებით — `SysWOW64`-ისთვის).

---

## 3. ციკლი (edit → build → verify → publish)

```bash
cd ~/flake
$EDITOR modules/nixos/xkb/symbols/ge-custom      # 1. ცვლილება მხოლოდ აქ
git commit -am "ge-custom: …"                     #    + nixos-rebuild, როგორც ყოველთვის

cd windows/keyboard
$EDITOR build.sh                                  # 2. VERSION++
nix shell nixpkgs#llvmPackages.clang-unwrapped nixpkgs#lld \
          nixpkgs#llvmPackages.llvm nixpkgs#python3 -c ./build.sh   # 3. აგება + შემოწმება
git add kbdgemtv.klc build.sh && git commit -m "windows/keyboard: vX.Y.Z"
# 4. dist/kbdgemtv-windows-X.Y.Z.zip → Drive „ქართული კლავიატურა Windows (kbdgemtv)“
```

მოსალოდნელი გამოსავალი თითო DLL-ზე: `50 keys checked, 0 mismatches`.

(⚠️ `nix shell` ბრძანება NixOS-ზე ჯერ არ გამიშვია; აგება შემოწმებულია Ubuntu-ზე clang 18 / lld 18-ით. `clang-unwrapped` იმიტომ, რომ Nix-ის wrapper glibc-ის ფლაგებს ამატებს, Windows target-ს კი ისინი არ სჭირდება.)

---

## 4. რას აკეთებს ინსტალერი

1. `install-system.ps1` (ადმინით): DLL → `System32` (+ `wow64` → `SysWOW64`), რეესტრი `HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0NN0437`: `Layout File`, `Layout Text`, `Layout Display Name`, `Layout Id` (თავისუფალი ნომერი).
2. `install.ps1` (მომხმარებლით): თუ იგივე DLL უკვე დაყენებულია — ადმინს არ ითხოვს; ქართულის სიაში ამატებს `0437:a0NN0437`-ს; ამოწმებს `ToUnicodeEx`-ით `Q`, `Shift+Q`, `CapsLock+Q`.

---

## 5. Pitfalls

| შეცდომა | რატომ ხდება | სწორი გზა |
|---|---|---|
| `kbdgemtv.klc`-ის ხელით შესწორება | შემდეგი `build.sh` გადაწერს; NixOS და Windows ერთმანეთს დაშორდება | მხოლოდ `ge-custom` → `build.sh` |
| `nix shell nixpkgs#clang` | wrapped clang Linux/glibc ფლაგებს ამატებს Windows target-ზე | `llvmPackages.clang-unwrapped` |
| ახალი DLL იმავე `VERSION`-ით | ინსტალერი ჰეშს ადარებს; ძველი, ჩატვირთული DLL ვერ გადაიწერება | `VERSION++`; კომპიუტერზე `uninstall.cmd` → reboot → `install.cmd` |
| Settings: „Unavailable input method“ ინსტალაციის შემდეგ | Windows-ს სესიაში განლაგება ჯერ არ ჩაუტვირთავს | Sign out → Sign in |
| `'{0:x4}' -f (Measure-Object).Maximum` | `Maximum` არის `double`, `x4`-ს `int` სჭირდება („Format specifier was invalid“) | `[int]` cast (გასწორებულია 1.0.1-ში) |
| `.ps1` UTF-8 BOM-ის გარეშე | Windows PowerShell 5.1 ქართულს ANSI-ად კითხულობს | ფაილები ინახება UTF-8 BOM + CRLF |
| `/section:.data,RE`-ის ამოღება | kbd DLL-ები ერთ, read+execute სექციად იწყობა (როგორც MSKLC/WDK) | `build.sh`-ის link ფლაგები არ შეცვალოთ |
