# windows/keyboard — ქართული განლაგებები Windows-ისთვის (მთავრულით)

| DLL | სახელი Windows-ში | წყარო | Caps Lock | ჰენდაუტი |
|---|---|---|---|---|
| `kbdgemtv.dll` | Georgian (Ergonomic, Mtavruli) - avto | NixOS-ის `modules/nixos/xkb/symbols/ge-custom` (+ `src/ergonomic.xkb`) | = Shift (Shift-იც მთავრულია) | [`keyboard-install.md`](../../docs/windows/keyboard-install.md) |
| `kbdgeqmt.dll` | Georgian (QWERTY, Mtavruli) | `src/ge-basic.xkb` = xkeyboard-config `ge(basic)` | ცალკე დონე: ყველა ქართული ასო → მთავრული, Shift-ის ასოც | [`keyboard-qwerty-install.md`](../../docs/windows/keyboard-qwerty-install.md) |

ერგონომიკული — ჩემთვის (NixOS-ის ასლი); QWERTY — სხვებისთვის: Windows-ის ჩვეულებრივი Georgian (QWERTY), სადაც Shift უკვე ჭ/ღ/თ/შ/ჟ/ძ/ჩ-ს წერს, ამიტომ მთავრული მხოლოდ Caps Lock-ით.

---

## 1. გადაწყვეტილების კლასიფიკაცია

- ფენა: **არც System, არც User** — ეს NixOS-ის კონფიგურაცია არ არის, ამიტომ `modules/`-ში და `home/`-ში არ დევს. ცალკე დირექტორიაა `windows/`, flake-ის evaluation-ში არ მონაწილეობს.
- წყარო: xkb ფაილები. `klc/*.klc` და DLL-ები გენერირდება, ხელით არ იცვლება.
- აგება: clang + lld-link (cross-compile Linux-ზე). MSKLC და Windows არ სჭირდება; ARM64 DLL-საც აგებს, რასაც MSKLC ვერ აკეთებს.
- Caps Lock-ის ორი რეჟიმი (`tools/xkb2klc.py --caps`):
  - `alpha` — Windows-ის `CAPLOK`: Caps = Shift. ერგონომიკულისთვის, სადაც Shift უკვე მთავრულია.
  - `sgcaps` — Windows-ის `SGCAPS`: Caps-ს საკუთარი სვეტები აქვს (Caps, Caps+Shift). ყველა ქართული ასო → მთავრული (U+10D0 → U+1C90), დანარჩენი უცვლელი. Caps-ის სტრიქონში Ctrl/AltGr სვეტები ძირითადის ასლია — Windows Caps Lock-ის დროს მთლიანად ამ სტრიქონს კითხულობს.

---

## 2. ფაილები

| ფაილი | რა არის | რედაქტირდება? |
|---|---|---|
| `build.sh` | ორივე განლაგება: xkb → klc → C ცხრილები → 4 DLL → შემოწმება → zip; ვერსიები და თვითშემოწმების ტესტები | `layout …` სტრიქონები, `tests_*` |
| `src/ergonomic.xkb` | xkeyboard-config-ის `ge(ergonomic)` (ზედა რიგი, `«»`), რომელსაც `ge-custom` `include`-ით იყენებს | იშვიათად |
| `src/ge-basic.xkb` | xkeyboard-config-ის `ge(basic)` — Georgian QWERTY (xkb-data 2.41) | იშვიათად |
| `src/kbdlayout.c` | kbd.h-თავსებადი სტრუქტურები, scan code → VK, `KbdLayerDescriptor` — საერთო ორივესთვის | იშვიათად |
| `src/kbdlayout.rc.in` | ვერსიის რესურსი + სტრიქონი 1000 (`Layout Display Name`), `@DLL@`/`@TEXT@` ჩანაცვლებით | — |
| `tools/xkb2klc.py` | xkb → `.klc` (`--caps alpha|sgcaps`) | — |
| `tools/klc2c.py` | `.klc` → `build/<id>/kbdlayout_tables.inc` (SGCAPS → დამატებითი სტრიქონი VK 0xFF) | — |
| `tools/verify_kbd.py` | აგებული DLL-დან კითხულობს KBDTABLES-ს და ადარებს `.klc`-ს (SGCaps-ის ჩათვლით) | — |
| `klc/*.klc` | გენერირებული; MSKLC-შიც იხსნება | **არა** |
| `installer/` | `install.cmd/.ps1`, `install-system.ps1`, `uninstall.cmd/.ps1` — საერთო; განლაგებას კითხულობს `layout.psd1`-დან (build.sh წერს) | — |
| `build/`, `dist/` | აგების შედეგი, `.gitignore`-შია | — |

DLL-ის ვარიანტები: `amd64` (x64), `i386` (32-ბიტიანი Windows), `arm64`, `wow64` (32-ბიტიანი კოდი 64-ბიტიანი პოინტერებით — `SysWOW64`-ისთვის).
პაკეტები: `dist/<slug>-<ver>.zip` (ყველა) და `dist/<slug>-<ver>-x64.zip` — slug: `windows-georgian-ergonomic-mtavruli`, `windows-georgian-qwerty-mtavruli`; (amd64 + wow64, სკოლისთვის).

---

## 3. ციკლი (edit → build → verify → publish)

```bash
cd ~/flake
$EDITOR modules/nixos/xkb/symbols/ge-custom      # 1. ერგონომიკულის ცვლილება მხოლოდ აქ
git commit -am "ge-custom: …"                     #    + nixos-rebuild, როგორც ყოველთვის

cd windows/keyboard
$EDITOR build.sh                                  # 2. შესაბამის `layout` სტრიქონში pkgver++
nix shell nixpkgs#llvmPackages.clang-unwrapped nixpkgs#lld \
          nixpkgs#llvmPackages.llvm nixpkgs#python3 -c ./build.sh   # 3. აგება + შემოწმება
git add klc build.sh && git commit -m "windows/keyboard: <id> vX.Y.Z"
# 4. dist/<slug>-X.Y.Z-x64.zip → Drive-ის შესაბამისი საქაღალდე
```

მოსალოდნელი გამოსავალი თითო DLL-ზე: `50 keys checked, 0 mismatches`.

(⚠️ `nix shell` ბრძანება NixOS-ზე ჯერ არ გამიშვია; აგება შემოწმებულია Ubuntu-ზე clang 18 / lld 18-ით. `clang-unwrapped` იმიტომ, რომ Nix-ის wrapper glibc-ის ფლაგებს ამატებს, Windows target-ს კი ისინი არ სჭირდება.)

---

## 4. რას აკეთებს ინსტალერი

1. `install-system.ps1` (ადმინით): DLL → `System32` (+ `wow64` → `SysWOW64`), რეესტრი `HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\a0NN0437`: `Layout File`, `Layout Text`, `Layout Display Name`, `Layout Id` (თავისუფალი ნომერი).
2. `install.ps1` (მომხმარებლით): თუ იგივე DLL უკვე დაყენებულია — ადმინს არ ითხოვს; ქართულის სიაში ამატებს `0437:a0NN0437`-ს (სხვა ქართულ განლაგებებს აშორებს, თუ არ არის `-KeepOtherGeorgian`); ამოწმებს `ToUnicodeEx`-ით `layout.psd1`-ის `Tests`-ს.

ორივე განლაგება ერთ კომპიუტერზე შეიძლება დადგეს — თითოს თავისი KLID და `Layout Id` აქვს.

---

## 5. Pitfalls

| შეცდომა | რატომ ხდება | სწორი გზა |
|---|---|---|
| `klc/*.klc`-ის ხელით შესწორება | შემდეგი `build.sh` გადაწერს; NixOS და Windows ერთმანეთს დაშორდება | მხოლოდ xkb წყარო → `build.sh` |
| SGCAPS-ის Caps სტრიქონში Ctrl/AltGr = `WCH_NONE` | Caps Lock-ის დროს Windows მთელ სტრიქონს კითხულობს → Caps+AltGr არაფერს წერს | `klc2c.py` ძირითადი სტრიქონის სვეტებს აკოპირებს; `verify_kbd.py` ამოწმებს |
| `@(@(0x10,0x80))` PowerShell-ში | ერთელემენტიანი მასივი ბრტყელდება → `@(0x10,0x80)` | `@(,@(0x10,0x80))` |
| `nix shell nixpkgs#clang` | wrapped clang Linux/glibc ფლაგებს ამატებს Windows target-ზე | `llvmPackages.clang-unwrapped` |
| ახალი DLL იმავე `VERSION`-ით | ინსტალერი ჰეშს ადარებს; ძველი, ჩატვირთული DLL ვერ გადაიწერება | `VERSION++`; კომპიუტერზე `uninstall.cmd` → reboot → `install.cmd` |
| Settings: „Unavailable input method“ ინსტალაციის შემდეგ | Windows-ს სესიაში განლაგება ჯერ არ ჩაუტვირთავს | Sign out → Sign in |
| `'{0:x4}' -f (Measure-Object).Maximum` | `Maximum` არის `double`, `x4`-ს `int` სჭირდება („Format specifier was invalid“) | `[int]` cast (გასწორებულია 1.0.1-ში) |
| `.ps1` UTF-8 BOM-ის გარეშე | Windows PowerShell 5.1 ქართულს ANSI-ად კითხულობს | ფაილები ინახება UTF-8 BOM + CRLF |
| `/section:.data,RE`-ის ამოღება | kbd DLL-ები ერთ, read+execute სექციად იწყობა (როგორც MSKLC/WDK) | `build.sh`-ის link ფლაგები არ შეცვალოთ |
