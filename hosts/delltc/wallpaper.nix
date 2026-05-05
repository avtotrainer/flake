{ config, pkgs, lib, ... }:

{
  # საჭირო პაკეტები
  environment.systemPackages = with pkgs; [
    swww
    wget
    coreutils
  ];

  systemd.user.services.wallpaper-rotate = {
    description = "Hyprland wallpaper rotation (picsum)";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -eu -c '
          LOG="$HOME/.cache/hypr/wallpaper.log"
          mkdir -p "$HOME/.cache/hypr"

          echo "[$(date)] start" >> "$LOG"

          ${pkgs.wget}/bin/wget \
            --max-redirect=3 \
            -O /tmp/wall.jpg \
            "https://picsum.photos/1920/1080?random=$(date +%s)" >> "$LOG" 2>&1

          SIZE=$(${pkgs.coreutils}/bin/stat -c%s /tmp/wall.jpg || echo 0)
          echo "[$(date)] size=$SIZE" >> "$LOG"

          if [ "$SIZE" -gt 50000 ]; then
            ${pkgs.swww}/bin/swww img /tmp/wall.jpg \
              --transition-type grow \
              --transition-step 60 >> "$LOG" 2>&1
            echo "[$(date)] applied" >> "$LOG"
          else
            echo "[$(date)] invalid image" >> "$LOG"
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
      OnUnitActiveSec = "3min"; # ⬅️ აქ ცვლი ინტერვალს
      Persistent = true;
    };
  };
}

