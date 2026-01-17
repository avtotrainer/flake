{ pkgs, lib, ... }:

{
  # Wayland-only სისტემა (X11 არ გვჭირდება)
  services.xserver.enable = false;

  # Hyprland compositor
  programs.hyprland.enable = true;

  # DM/greetd გამორთული — აღარ გვინდა boot-critical layer
  services.greetd.enable = false;
  services.displayManager.enable = false;

  # ------------------------------------------------------------
  # Declarative autostart (NixOS-style): systemd USER services
  #
  # იდეა:
  # 1) სისტემური autologin (TTY1) მოგვცემს user session-ს
  # 2) user systemd service ავტომატურად გაუშვებს Hyprland-ს
  # 3) მეორე user service ავტომატურად გაუშვებს Waybar-ს Hyprland-ის შემდეგ
  #
  # ეს არის:
  # - portable (ყველა კომპზე იგივე)
  # - rollback-safe
  # - shell/profile-სგან დამოუკიდებელი
  # ------------------------------------------------------------

  systemd.user.services.hyprland-autostart = {
    Unit = {
      Description = "Hyprland (auto-start on TTY1)";
      # TTY login-ის შემდეგ user manager უკვე გაშვებულია,
      # ამიტომ default.target საკმარისია.
      After = [ "default.target" ];
    };

    Service = {
      Type = "simple";

      # მხოლოდ მაშინ ვუშვებთ, როცა:
      # - ვართ TTY1-ზე (XDG_VTNR=1)
      # - უკვე არ ვართ Wayland session-ში
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

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Waybar-ს ვმართავთ systemd user service-ით და ვაბამთ Hyprland-ზე.
  # Home Manager აგრძელებს waybar-ის კონფიგების მართვას (config/style),
  # მაგრამ start/stop ლოგიკა აქ, სისტემურადაა.
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar (start after Hyprland)";
      After = [ "hyprland-autostart.service" ];
      Requires = [ "hyprland-autostart.service" ];
      PartOf = [ "hyprland-autostart.service" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

