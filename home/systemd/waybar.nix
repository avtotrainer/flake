{ pkgs, ... }:

let
  ##################################################
  # WAYLAND SOCKET WAIT SCRIPT
  #
  # საჭიროა იმიტომ, რომ:
  # - systemd შეიძლება Waybar-ს ძალიან ადრე გაუშვებს
  # - Hyprland IPC ჯერ არ იყოს მზად
  ##################################################
  waitForWayland = pkgs.writeShellScript "wait-for-wayland" ''
    for i in $(seq 1 50); do
      if [ -S "$XDG_RUNTIME_DIR/wayland-0" ] || [ -S "$XDG_RUNTIME_DIR/wayland-1" ]; then
        exit 0
      fi
      sleep 0.1
    done

    echo "Wayland socket not found"
    exit 1
  '';
in
{
  ##################################################
  # WAYBAR SYSTEMD USER SERVICE
  ##################################################
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar (start after graphical session)";

      # graphical-session.target უკვე უნდა არსებობდეს
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";

      # ჯერ დაველოდოთ Wayland socket-ს
      ExecStartPre = waitForWayland;

      # შემდეგ გავუშვათ Waybar
      ExecStart = "${pkgs.waybar}/bin/waybar";

      Restart = "on-failure";
    };

    Install = {
      # Waybar ავტომატურად ებმება გრაფიკულ სესიას
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

