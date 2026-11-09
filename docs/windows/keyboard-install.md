# ქართული ერგონომიკული კლავიატურა მთავრულით — Windows-ზე ინსტალაცია

ეს ჰენდაუტი აღწერს, როგორ დავაყენოთ Windows-ის კომპიუტერზე იგივე ქართული განლაგება, რაც NixOS-ზე გვაქვს: ერგონომიკული ქართული, სადაც **Caps Lock** და **Shift** მთავრულს წერს.

ფაილის სახელი: `windows-georgian-ergonomic-mtavruli-1.1.0-x64.zip`
განლაგების სახელი Windows-ში: **Georgian (Ergonomic, Mtavruli) - avto**

---

## 1. რას აკეთებს განლაგება

| კლავიში | შედეგი | მაგალითი |
|---|---|---|
| ასო | ქართული ასო (ერგონომიკული განლაგება) | `D` → ა |
| Shift + ასო | მთავრული | `Shift+D` → Ა |
| Caps Lock + ასო | მთავრული | ქართული → ᲥᲐᲠᲗᲣᲚᲘ |
| AltGr (მარჯვენა Alt) + ასო | ლათინური დიდი ასო | `AltGr+D` → D |
| AltGr + `[ ] ; ' , . /` | `{ } : " < > ?` | |
| Shift + AltGr + ასო | ძველი ასოები და სიმბოლოები | ჴ ჵ ჶ ჷ ჳ ჲ ჱ, ₾ ✓ • ℹ § € © |
| ზედა რიგი | `! № , ; % : ? . ( )`; Shift-ით — ციფრები | `Shift+1` → 1 |

ენის გადართვა: **Win + Space**.

---

## 2. რა გჭირდებათ

- Windows 10 (ვერსია 1607 ან ახალი) ან Windows 11, **64-ბიტიანი, Intel/AMD პროცესორით** — ასეთია სკოლის თითქმის ყველა კომპიუტერი.
  შემოწმება: Settings → System → About → **System type**: „64-bit operating system, x64-based processor“.
  ARM ან 32-ბიტიანი Windows-ისთვის საჭიროა სრული პაკეტი `windows-georgian-ergonomic-mtavruli-1.1.0.zip` (`dist/`-დან, `build.sh`-ის შედეგი).
- **ადმინისტრატორის პაროლი** — მხოლოდ ერთხელ თითო კომპიუტერზე.
- ფაილი `windows-georgian-ergonomic-mtavruli-1.1.0-x64.zip`.

### სად ავიღოთ ფაილი

**Google Drive** (რეკომენდებული სკოლაში): საქაღალდე „ქართული კლავიატურა Windows (kbdgemtv)“
https://drive.google.com/drive/folders/1FW8YVg316gqT8j1G5fLfpDmXdsT-o0CC
პირდაპირ ფაილი: https://drive.google.com/file/d/1eAEPVqQ7OOwzOgsgKOjEtma2-pG735or/view

შედით ბრაუზერში din.ge ანგარიშით, მარჯვენა ღილაკი zip ფაილზე → **Download**.

> **რატომ Drive და არა GitHub?** სკოლის ქსელში 22-ე პორტი იბლოკება. ეს აფერხებს `git clone git@github.com:…`-ს (SSH), მაგრამ არა ჩვეულებრივ ჩამოტვირთვას ბრაუზერით (HTTPS, პორტი 443). Drive ყველგან ერთნაირად მუშაობს, ამიტომ სკოლისთვის ის არის მთავარი წყარო.

---

## 3. ინსტალაცია (ერთი კომპიუტერი)

1. **ჩამოტვირთეთ** `windows-georgian-ergonomic-mtavruli-1.1.0-x64.zip` (მაგალითად, `Downloads` საქაღალდეში).
2. **ამოაარქივეთ**: მარჯვენა ღილაკი → **Extract All…** → **Extract**.
   გაჩნდება საქაღალდე `kbdgemtv`. *zip-ის შიგნიდან პირდაპირ ნუ გაუშვებთ — ფაილები ვერ მოიძებნება.*
3. საქაღალდეში `kbdgemtv` ორჯერ დააწკაპუნეთ **`install.cmd`**-ზე.
   - თუ გამოჩნდა „Windows protected your PC“ → **More info** → **Run anyway**.
4. გამოჩნდება UAC ფანჯარა → **Yes** (ან ადმინის პაროლი).
5. დაელოდეთ შავ ფანჯარაში შემოწმებას — `Q -> ჩ`, `Shift+Q -> Ჩ`, `CapsLock+Q -> Ჩ` და ბოლოს მწვანე **შემოწმება: OK**.
   ეს ნიშნავს, რომ განლაგება სწორად მუშაობს. დააჭირეთ ნებისმიერ ღილაკს.
6. **გამოდით სისტემიდან და ხელახლა შედით** (Start → მომხმარებლის სახელი → **Sign out**).
   ამის გარეშე Settings-ში შეიძლება ეწეროს „Unavailable input method“.

**მოსალოდნელი შედეგი:** Settings → Time & language → Language & region → Georgian → Options → Keyboards-ში ჩანს **Georgian (Ergonomic, Mtavruli) - avto**.

---

## 4. სხვა მომხმარებლები იმავე კომპიუტერზე (მოსწავლეები)

განლაგება სისტემაში ერთხელ დგება, მაგრამ **თითო მომხმარებლის ენების სიაში ცალკე ემატება**.

- თითო ანგარიშში გაუშვით `install.cmd` (საქაღალდე შეიძლება იყოს `C:\Users\Public\kbdgemtv`).
  მეორე ჯერიდან ადმინი **აღარ სჭირდება** — სკრიპტი წერს: „სისტემური ნაწილი უკვე დაყენებულია — ადმინი არ სჭირდება“.
- **ახალი ანგარიშებისთვის ავტომატურად** (Windows-ის ჩაშენებული ფუნქცია, ადმინით):
  Settings → Time & language → Language & region → **Administrative language settings** → **Copy settings…** → მონიშნეთ **New user accounts** → OK.
  ასე ყველა ახალი ანგარიში იგივე ენებს და განლაგებას მიიღებს.

---

## 5. შემოწმება

გახსენით **Notepad**, გადართეთ ქართულზე (Win + Space), ჩართეთ **Caps Lock** და აკრიფეთ `ქართული`.
სწორი შედეგი: **ᲥᲐᲠᲗᲣᲚᲘ**.

---

## 6. ხშირი პრობლემები

| რას ხედავთ | რატომ ხდება | რა უნდა გააკეთოთ |
|---|---|---|
| Settings-ში „Unavailable input method“ | Windows-ს ახალი განლაგება ჯერ არ ჩაუტვირთავს | Sign out → ხელახლა შესვლა (ან გადატვირთვა) |
| `install.cmd`-ზე არაფერი ხდება / ფაილი ვერ მოიძებნა | zip ამოარქივებული არ არის | Extract All… და გაუშვით ამოარქივებული საქაღალდიდან |
| ამოარქივებისას შეცდომა (CRC, „damaged“) | ფაილი ბოლომდე ვერ ჩამოიტვირთა | წაშალეთ და თავიდან ჩამოტვირთეთ Drive-იდან |
| UAC ითხოვს პაროლს, რომელიც არ იცით | მოსწავლის ანგარიშს ადმინის უფლება არ აქვს | პირველი ინსტალაცია გააკეთოს ადმინმა; შემდეგ მოსწავლის ანგარიშში `install.cmd` ადმინს აღარ ითხოვს |
| „… ვერ ჩაიწერა (ალბათ ძველი ვერსია გამოიყენება)“ | ძველი DLL ამ წუთას ჩატვირთულია | `uninstall.cmd` → გადატვირთვა → `install.cmd` |
| მთავრულის ნაცვლად კვადრატები `□□□` | პროგრამის შრიფტს მთავრული არ აქვს | შრიფტად აირჩიეთ **Noto Sans Georgian** ან Sylfaen |
| სიაში ჩანს Windows-ის სხვა ქართული განლაგებებიც | დაყენებულია `-KeepOtherGeorgian`-ით, ან ხელით დაემატა | Settings → Georgian → Options → ზედმეტი → Remove |

---

## 7. წაშლა

1. საქაღალდეში `kbdgemtv` გაუშვით **`uninstall.cmd`** → UAC → **Yes**.
2. თუ წერს „გამოყენებაშია“ — გადატვირთეთ კომპიუტერი და კიდევ ერთხელ გაუშვით `uninstall.cmd`.

---

## 8. პაკეტის აგება (მასწავლებლისთვის, NixOS-ზე)

განლაგების ერთადერთი წყაროა `modules/nixos/xkb/symbols/ge-custom`. Windows-ის ვერსია მისგან გენერირდება — ხელით არაფერი იცვლება.

```bash
cd ~/flake/windows/keyboard
nix shell nixpkgs#llvmPackages.clang-unwrapped nixpkgs#lld nixpkgs#llvmPackages.llvm nixpkgs#python3 -c ./build.sh
```

შედეგი: `dist/windows-georgian-ergonomic-mtavruli-<VERSION>.zip` (ყველა არქიტექტურა) და `dist/windows-georgian-ergonomic-mtavruli-<VERSION>-x64.zip` (სკოლისთვის); იგივე `kbdgeqmt`-ისთვის — x64 ატვირთეთ Drive-ის საქაღალდეში (ძველი ვერსია წაშალეთ). `build.sh` თითოეულ DLL-ს ამოწმებს (`50 keys checked, 0 mismatches`) და აგება განმეორებადია (`/Brepro`): იგივე წყარო → ბაიტ-ბაიტ იგივე DLL.

დეტალები: `windows/keyboard/README.md`. QWERTY ვერსია სხვებისთვის: [`keyboard-qwerty-install.md`](keyboard-qwerty-install.md).
