{ pkgs, ... }:

{
  systemd.user.services.hyprland-graphical-session = {
    Unit = {
      Description = "Activate graphical-session.target for Hyprland";
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl --user start graphical-session.target";
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };
}

