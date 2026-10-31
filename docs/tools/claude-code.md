# Claude Code NixOS flake-ში

Claude Code არის Anthropic-ის აგენტური კოდირების ინსტრუმენტი ტერმინალისთვის: კითხულობს პროექტს, არედაქტირებს ფაილებს, უშვებს ბრძანებებს, მუშაობს git-თან.

---

## 1. გადაწყვეტილების კლასიფიკაცია

- ფენა: **User Layer** (CLI ინსტრუმენტი → `home/avto.nix`)
- წყარო: community flake `github:sadjow/claude-code-nix` — overlay `pkgs.claude-code`
- რატომ არა nixpkgs: nixpkgs-ის `claude-code` ვერსია კვირებით აგვიანებს, Claude Code კი ხშირად ახლდება.
- რატომ არა ოფიციალური `curl … | bash` ინსტალერი: ის დეკლარაციული არ არის (ფაილებს `~`-ში წერს და თავისით ახლდება), არ არის rollback-able და NixOS-ზე წინასწარ აწყობილ binary-ს შეიძლება dynamic linker-ის პრობლემა ჰქონდეს.

---

## 2. რომელი ფაილები მონაწილეობს

| ფაილი | რა შეიცვალა | ფენა |
|---|---|---|
| `flake.nix` | input `claude-code` (`follows = "nixpkgs"`), `outputs = inputs@{…}`, `specialArgs = { inherit inputs; }` სამივე host-ზე | wiring |
| `modules/nixos/overlays.nix` | ახალი: `nixpkgs.overlays = [ inputs.claude-code.overlays.default ]` | System |
| `hosts/{laptop,delltc,wsl}/default.nix` | import `../../modules/nixos/overlays.nix` | შემკრები |
| `home/avto.nix` | `home.packages`-ში `claude-code` | User |

### რატომ არის overlay System Layer-ში

`users`-ის მიბმაში `home-manager.useGlobalPkgs = true`. ეს ნიშნავს, რომ Home Manager იყენებს **სისტემის** `pkgs`-ს და HM-ის `nixpkgs.overlays` იგნორირდება. ამიტომ overlay სისტემის დონეზე ემატება, პაკეტი კი — user-ის დონეზე.

### unfree

Claude Code საკუთრების (proprietary) პროგრამაა. `modules/nixos/base.nix`-ში უკვე არის `nixpkgs.config.allowUnfree = true;` — დამატებით არაფერი სჭირდება. overlay იყენებს `final.callPackage`-ს, ანუ ჩვენს pkgs-ს, ჩვენი config-ით.

---

## 3. ციკლი (edit → commit → rebuild → verify)

```bash
cd ~/flake
git pull

# ახალი input lock-ში (ცვლის მხოლოდ claude-code-ს, სხვა input-ებს არ ეხება)
nix flake lock
git add flake.lock
git commit -m "flake.lock: add claude-code input"

# ჯერ build (activation-ის გარეშე), მერე switch
sudo nixos-rebuild build --flake .#laptop
sudo nixos-rebuild switch --flake .#laptop

# verify
claude --version
```

პირველი გაშვება: `claude` → შესვლა ბრაუზერში Claude-ის ანგარიშით (Pro/Max/Team/Enterprise ან Console). შემდეგ — `/doctor`.

### განახლება

```bash
nix flake update claude-code
git commit -am "flake.lock: update claude-code"
sudo nixos-rebuild switch --flake .#laptop
```

---

## 4. Pitfalls

| შეცდომა | რატომ ხდება | სწორი გზა |
|---|---|---|
| `error: attribute 'claude-code' missing` | overlay არ არის ჩართული host-ზე, ან `pkgs.claude-code` HM-ში overlay-ის გარეშე გამოიყენება | შეამოწმე `overlays.nix`-ის import host-ის `default.nix`-ში |
| `error: undefined variable 'inputs'` / `attribute 'inputs' missing` | `specialArgs = { inherit inputs; }` აკლია host-ს `flake.nix`-ში | ყოველ `nixosSystem`-ს უნდა ჰქონდეს `specialArgs` |
| overlay ჩასმულია `home/avto.nix`-ში და არ მუშაობს | `useGlobalPkgs = true` HM-ის overlay-ს აიგნორებს | overlay — მხოლოდ System Layer-ში |
| `nixos-rebuild`-მა თავად შეცვალა `flake.lock` | lock-ში input არ იყო; rebuild დაუკომიტებელი lock-ით არღვევს წესს | ჯერ `nix flake lock` → commit → მერე rebuild |
| Claude Code ცდილობს თავისით განახლებას | Nix store read-only-ია; განახლება Nix-ის საქმეა | განახლება მხოლოდ `nix flake update claude-code`-ით |
| `curl … \| bash` ინსტალაცია დამატებით | ორი ვერსია PATH-ში, გაურკვეველი რომელი ეშვება | მხოლოდ Nix-ით; `which claude` → `/etc/profiles/per-user/avto/bin/claude` |

---

## 5. შემოწმება ფაზების მიხედვით

- **evaluation:** `nix eval .#nixosConfigurations.laptop.config.home-manager.users.avto.home.packages --apply 'map (p: p.name)'` — სიაში უნდა ჩანდეს `claude-code-…`
- **build:** `nixos-rebuild build` — შეცდომისას `nix log <drv>`
- **activation:** `which claude`, `claude --version`

წყაროები: https://code.claude.com/docs/en/quickstart · https://github.com/sadjow/claude-code-nix
