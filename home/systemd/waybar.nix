{ pkgs, ... }:

{
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar (start after Wayland is ready)";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };

    Service = {
      ExecStartPre = ''
        ${pkgs.bash}/bin/bash -c '
          for i in {1..50}; do
            if [ -S "$XDG_RUNTIME_DIR/wayland-1" ] || [ -S "$XDG_RUNTIME_DIR/wayland-0" ]; then
              exit 0
            fi
            sleep 0.1
          done
          exit 1
        '
      '';

      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

