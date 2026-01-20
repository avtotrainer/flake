{ config, ... }:

{
  # ─────────────────────────────────────────────
  # Waybar scripts (source of truth)
  # ─────────────────────────────────────────────
  xdg.configFile."waybar/scripts/kbdc.sh" = {
    source = ./scripts/kbdc.sh;
    executable = true;
  };

  xdg.configFile."waybar/scripts/kbd-toggle.sh" = {
    source = ./scripts/kbd-toggle.sh;
    executable = true;
  };

  programs.waybar = {
    enable = true;

    style = ./style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [ "clock" ];

        modules-right = [
          "cpu"
          "memory"
          "network"
          "custom/separator"
          "pulseaudio"
          "custom/separator"
          "battery"
          "custom/separator"
          "custom/kbd"
        ];

        "custom/kbd" = {
          exec = "${config.xdg.configHome}/waybar/scripts/kbdc.sh";
          interval = 1;
          return-type = "json";
          on-click = "${config.xdg.configHome}/waybar/scripts/kbd-toggle.sh";
          tooltip = "Click to switch language";
        };
      };
    };
  };
}

