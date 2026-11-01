# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Flake-based NixOS + Home Manager configuration for user `avto`, NixOS **25.11+ only** (never suggest or reference older versions, channels, or non-flake approaches). It doubles as a teaching reference, so docs and comments are written in Georgian — match that language when editing them.

## Hosts and commands

`nixosConfigurations`: `laptop` (main dev machine), `delltc`, `wsl` (uses `nixos-wsl`). Always target a host explicitly:

```bash
sudo nixos-rebuild build  --flake .#laptop   # evaluate + build, no activation
sudo nixos-rebuild test   --flake .#laptop   # activate until reboot
sudo nixos-rebuild switch --flake .#laptop   # daily
sudo nixos-rebuild boot   --flake .#laptop   # kernel/bootloader/low-level changes
nix flake update <input>                     # update one input, e.g. claude-code
nix eval .#nixosConfigurations.laptop.config.<option>   # check a value without building
```

`Makefile` = generation cleanup only (`make list`, `make last N=3`, `make keep-file` via a `KEEP` file, `make gc`, `make boot`). Note `make boot` is hardcoded to `.#laptop`.

## Mandatory workflow

`edit → git commit → nixos-rebuild → verify`. Never rebuild with uncommitted changes, and never let `nixos-rebuild` modify `flake.lock` implicitly — run `nix flake lock`/`update`, commit the lock, then rebuild. `flake.lock` is always committed and never hand-edited. Don't commit or rebuild on the user's behalf unless asked.

## Architecture rules (from docs/PROJECT-RULES.md — these take priority)

- `flake.nix` is wiring only — no logic. Every `nixosSystem` passes `specialArgs = { inherit inputs; }` and attaches Home Manager with `useGlobalPkgs = true`, `useUserPackages = true`, `backupFileExtension = "bak"`.
- `hosts/<host>/default.nix` is an assembler: imports `hardware.nix`, host-specific files, then shared `modules/nixos/*`, `profiles/nixos/*`, and `users/*`. `hardware.nix` holds hardware only. New hosts are created by copying and adapting, not by cross-linking.
- **Strict System vs User split.** System layer (NixOS modules): hardware, kernel, services, WM/DM (Hyprland), networking, security. User layer (Home Manager, `home/avto.nix` + `home/*/`): shell, editor, CLI tools, user services. Never move system/desktop logic into Home Manager; never use `home-manager switch` for system concerns.
- Because `useGlobalPkgs = true`, overlays set inside Home Manager are ignored — overlays live in `modules/nixos/overlays.nix` (system layer) even when the package is installed via `home.packages`. `allowUnfree` is set in `modules/nixos/base.nix`.
- WSL vs desktop branching is done in-module: `home/avto.nix` checks `osConfig.wsl.enable`; `profiles/nixos/dev.nix` uses `lib.attrByPath [ "wsl" "enable" ] false config`. GUI pieces (waybar, alacritty, `home/config`, vscode, chrome) are excluded on WSL.
- Claude Code itself comes from the `sadjow/claude-code-nix` overlay (see `docs/tools/claude-code.md`); it cannot self-update from the read-only store — update via `nix flake update claude-code`.

## Troubleshooting conventions

- First identify the failing phase: evaluation / build / activation / boot. The `nixos-rebuild` output is the primary source.
- Read evaluation traces bottom-up; a frame pointing into `/nix/store` is never the place to fix. Only edit a file once the trace points to the exact source.
- Build failures → `nix log <drv>`; activation → `systemctl` / `journalctl`; boot → previous generation's logs.
- Docs under `docs/` should state the typical mistake, why it's wrong, and the correct way (pitfalls tables), with commands always given in context.

## Gotchas

- `*.bak` files are Home Manager backups / old copies, not live config.
