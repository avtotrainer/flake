{ pkgs, ... }:

{
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar (wait for Wayland socket)";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";

      ExecStartPre = [
        "${pkgs.bash}/bin/bash"
        "-c"
        ''
          for i in $(seq 1 50); do
            if [ -S "$XDG_RUNTIME_DIR/wayland-0" ] || [ -S "$XDG_RUNTIME_DIR/wayland-1" ]; then
              exit 0
            fi
            sleep 0.1
          done
          echo "Wayland socket not found"
          exit 1
        ''
      ];

      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

