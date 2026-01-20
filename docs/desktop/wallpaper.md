# Desktop Wallpaper — NixOS (flake)

## მიზანი

დინამიური და ესტეტიური ვოლპეიპერის მიღება Wayland + Hyprland გარემოში, დეკლარატიულად და rollback-ის მხარდაჭერით.

---

## სად იდება?

```
hosts/laptop/wallpaper.nix
```

ვოლპეიპერის ლოგიკა არის **desktop behavior** და ეკუთვნის კონკრეტულ host-ს.

---

## სად იმპორტდება?

```
hosts/laptop/default.nix
```

```nix
imports = [
  ./wallpaper.nix
];
```

`default.nix` არის host-ის ერთადერთი შემკრები.

---

## რა ფაზაში აქტიურდება?

* `environment.systemPackages` → **build**
* `systemd.user.services.*` → **activation**
* `systemd.user.timers.*` → **activation**

---

## საჭირო პაკეტები

* `swww` — Wayland wallpaper backend
* `wget` — სურათის ჩამოტვირთვა
* `coreutils` — საბაზისო იუნიქს ინსტრუმენტები

პაკეტები ემატება system layer-ში.

---

## სერვისი და ტაიმერი

`hosts/laptop/wallpaper.nix`

```nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    swww
    wget
    coreutils
  ];

  systemd.user.services.wallpaper-rotate = {
    description = "Dynamic wallpaper (Wayland)";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -eu -c '
          LOG="$HOME/.cache/hypr/wallpaper.log"
          mkdir -p "$(dirname "$LOG")"

          ${pkgs.wget}/bin/wget \
            --max-redirect=3 \
            -O /tmp/wall.jpg \
            "https://picsum.photos/1920/1080?random=$(date +%s)" >> "$LOG" 2>&1

          SIZE=$(${pkgs.coreutils}/bin/stat -c%s /tmp/wall.jpg || echo 0)

          if [ "$SIZE" -gt 50000 ]; then
            ${pkgs.swww}/bin/swww img /tmp/wall.jpg \
              --transition-type grow \
              --transition-step 60 >> "$LOG" 2>&1
          fi
        '
      '';
    };
  };

  systemd.user.timers.wallpaper-rotate = {
    description = "Wallpaper rotation timer";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "30min";
      Persistent = true;
    };
  };
}
```

---

## როგორ მოწმდება?

```bash
systemctl --user status wallpaper-rotate.service
systemctl --user list-timers | grep wallpaper
journalctl --user -u wallpaper-rotate
```

---

## რებილდი

```bash
git add .
git commit -m "docs/system: desktop wallpaper"
sudo nixos-rebuild switch --flake .#laptop
```

---

## დასკვნა

* wallpaper.nix → `hosts/<host>/`
* import → `hosts/<host>/default.nix`
* activation → systemd user units
* verification → systemctl / journalctl

