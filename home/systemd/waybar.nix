{ pkgs, ... }:

let
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
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar (wait for Wayland socket)";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStartPre = waitForWayland;
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

