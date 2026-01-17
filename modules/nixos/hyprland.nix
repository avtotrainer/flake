{ pkgs, lib, ... }:

{
  services.xserver.enable = false;

  programs.hyprland.enable = true;

  services.greetd.enable = false;
  services.displayManager.enable = false;

  # ------------------------------------------------------------
  # Declarative autostart via systemd USER services
  # ------------------------------------------------------------

  systemd.user.services.hyprland-autostart = {
    description = "Hyprland (auto-start on TTY1)";
    after = [ "default.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -lc '
          if [ "''${XDG_VTNR:-}" = "1" ] && [ -z "''${WAYLAND_DISPLAY:-}" ]; then
            exec ${pkgs.hyprland}/bin/hyprland
          else
            exit 0
          fi
        '
      '';
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  systemd.user.services.waybar = {
    description = "Waybar (start after Hyprland)";
    after = [ "hyprland-autostart.service" ];
    requires = [ "hyprland-autostart.service" ];
    partOf = [ "hyprland-autostart.service" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };
}

