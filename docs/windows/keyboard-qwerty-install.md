# ქართული QWERTY კლავიატურა მთავრულით — Windows-ზე ინსტალაცია

ეს არის Windows-ის ჩვეულებრივი **Georgian (QWERTY)** განლაგება ერთი დამატებით: **Caps Lock-ით იწერება მთავრული**.
ყველაფერი დანარჩენი — ასოების ადგილი, Shift-ით აკრეფილი ასოები (ჭ, ღ, თ, შ, ჟ, ძ, ჩ) — უცვლელია.

ფაილის სახელი: `windows-georgian-qwerty-mtavruli-1.0.0-x64.zip`
განლაგების სახელი Windows-ში: **Georgian (QWERTY, Mtavruli)**

---

## 1. როგორ მუშაობს

ამ განლაგებაში Shift უკვე დაკავებულია (`W` → წ, `Shift+W` → ჭ), ამიტომ მთავრული **მხოლოდ Caps Lock-ით** იწერება.

| Caps Lock | კლავიში | შედეგი |
|---|---|---|
| გამორთული | `W` | წ |
| გამორთული | `Shift+W` | ჭ |
| **ჩართული** | `W` | **Წ** |
| **ჩართული** | `Shift+W` | **Ჭ** |
| ჩართული | `S`, `Shift+S` | Ს, Შ |
| ჩართული | `Shift+Q` (ლათინური) | Q — Caps Lock მხოლოდ ქართულ ასოებს ცვლის |

მაგალითი: Caps Lock → `saqarTvelo` (`T` = Shift+T) → **ᲡᲐᲥᲐᲠᲗᲕᲔᲚᲝ**.
ციფრები, სასვენი ნიშნები და AltGr (მარჯვენა Alt) იგივეა, რაც Windows-ის ჩვეულებრივ Georgian (QWERTY)-ში.

ენის გადართვა: **Win + Space**.

---

## 2. რა გჭირდებათ

- Windows 10 (ვერსია 1607 ან ახალი) ან Windows 11, **64-ბიტიანი, Intel/AMD პროცესორით** — ასეთია სკოლის თითქმის ყველა კომპიუტერი.
  შემოწმება: Settings → System → About → **System type**: „64-bit operating system, x64-based processor“.
- **ადმინისტრატორის პაროლი** — მხოლოდ ერთხელ თითო კომპიუტერზე.
- ფაილი `windows-georgian-qwerty-mtavruli-1.0.0-x64.zip`.

### სად ავიღოთ ფაილი

Google Drive, საქაღალდე „ქართული QWERTY კლავიატურა მთავრულით — Windows (kbdgeqmt)“
https://drive.google.com/drive/folders/1F7FrejPVZp2BFFB5Wcw2FbWRPaRjdmkQ
პირდაპირ ფაილი: https://drive.google.com/file/d/1kxV0Ry6zEGzQI6cKjdKWqatHtsmTU-Zw/view

---

## 3. ინსტალაცია (ერთი კომპიუტერი)

1. **ჩამოტვირთეთ** `windows-georgian-qwerty-mtavruli-1.0.0-x64.zip`.
2. **ამოაარქივეთ**: მარჯვენა ღილაკი → **Extract All…** → **Extract**. გაჩნდება საქაღალდე `kbdgeqmt`.
   *zip-ის შიგნიდან პირდაპირ ნუ გაუშვებთ — ფაილები ვერ მოიძებნება.*
3. საქაღალდეში `kbdgeqmt` ორჯერ დააწკაპუნეთ **`install.cmd`**-ზე.
   თუ გამოჩნდა „Windows protected your PC“ → **More info** → **Run anyway**.
4. UAC ფანჯარა → **Yes** (ან ადმინის პაროლი).
5. შავ ფანჯარაში სკრიპტი თავად ამოწმებს განლაგებას — `W -> წ`, `Shift+W -> ჭ`, `CapsLock+W -> Წ`, `CapsLock+Shift+W -> Ჭ` … — და ბოლოს წერს მწვანე **შემოწმება: OK**. დააჭირეთ ნებისმიერ ღილაკს.
6. **გამოდით სისტემიდან და ხელახლა შედით** (Start → მომხმარებლის სახელი → **Sign out**).
   ამის გარეშე Settings-ში შეიძლება ეწეროს „Unavailable input method“.

**მოსალოდნელი შედეგი:** Settings → Time & language → Language & region → Georgian → Options → Keyboards-ში ჩანს **Georgian (QWERTY, Mtavruli)**. ინსტალერი ამ სიიდან Windows-ის ძველ ქართულ განლაგებას აშორებს — ახალი მას სრულად ცვლის.

---

## 4. სხვა მომხმარებლები იმავე კომპიუტერზე (მოსწავლეები)

განლაგება სისტემაში ერთხელ დგება, მაგრამ **თითო მომხმარებლის ენების სიაში ცალკე ემატება**.

- თითო ანგარიშში გაუშვით `install.cmd` (საქაღალდე მოსახერხებელია `C:\Users\Public\kbdgeqmt`-ში).
  მეორე ჯერიდან ადმინი **აღარ სჭირდება** — სკრიპტი წერს: „სისტემური ნაწილი უკვე დაყენებულია — ადმინი არ სჭირდება“.
- **ახალი ანგარიშებისთვის ავტომატურად** (ადმინით):
  Settings → Time & language → Language & region → **Administrative language settings** → **Copy settings…** → მონიშნეთ **New user accounts** → OK.

---

## 5. შემოწმება

გახსენით **Notepad**, გადართეთ ქართულზე (Win + Space), ჩართეთ **Caps Lock** და აკრიფეთ `Wadraki` (Shift+W, a, d, r, a, k, i).
სწორი შედეგი: **ᲭᲐᲓᲠᲐᲙᲘ**.

---

## 6. ხშირი პრობლემები

| რას ხედავთ | რატომ ხდება | რა უნდა გააკეთოთ |
|---|---|---|
| Settings-ში „Unavailable input method“ | Windows-ს ახალი განლაგება ჯერ არ ჩაუტვირთავს | Sign out → ხელახლა შესვლა (ან გადატვირთვა) |
| Caps Lock-ით მაინც მხედრული იწერება | არჩეულია Windows-ის ძველი Georgian (QWERTY) | Win + Space → **Georgian (QWERTY, Mtavruli)** |
| `install.cmd`-ზე არაფერი ხდება / ფაილი ვერ მოიძებნა | zip ამოარქივებული არ არის | Extract All… და გაუშვით ამოარქივებული საქაღალდიდან |
| ამოარქივებისას შეცდომა (CRC, „damaged“) | ფაილი ბოლომდე ვერ ჩამოიტვირთა | წაშალეთ და თავიდან ჩამოტვირთეთ |
| UAC ითხოვს პაროლს, რომელიც არ იცით | მოსწავლის ანგარიშს ადმინის უფლება არ აქვს | პირველი ინსტალაცია გააკეთოს ადმინმა; შემდეგ მოსწავლის ანგარიშში ადმინი აღარ სჭირდება |
| მთავრულის ნაცვლად კვადრატები `□□□` | პროგრამის შრიფტს მთავრული არ აქვს | შრიფტად აირჩიეთ **Noto Sans Georgian** ან Sylfaen |

---

## 7. წაშლა

1. საქაღალდეში `kbdgeqmt` გაუშვით **`uninstall.cmd`** → UAC → **Yes**.
2. თუ წერს „გამოყენებაშია“ — გადატვირთეთ კომპიუტერი და კიდევ ერთხელ გაუშვით `uninstall.cmd`.

---

## 8. პაკეტის აგება (მასწავლებლისთვის, NixOS-ზე)

წყარო: `windows/keyboard/src/ge-basic.xkb` (xkeyboard-config-ის `ge(basic)` = Georgian QWERTY). Caps Lock-ის დონე (`SGCaps`) `tools/xkb2klc.py --caps sgcaps` თავად ამატებს: თითო ქართულ ასოს — მისი მთავრული.

```bash
cd ~/flake/windows/keyboard
nix shell nixpkgs#llvmPackages.clang-unwrapped nixpkgs#lld nixpkgs#llvmPackages.llvm nixpkgs#python3 -c ./build.sh
```

შედეგი: `dist/windows-georgian-qwerty-mtavruli-<VERSION>-x64.zip` → Drive. დეტალები: `windows/keyboard/README.md`.
