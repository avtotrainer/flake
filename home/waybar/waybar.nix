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

 xdg.configFile."waybar/scripts/confirm-shutdown.sh" = {
    source = ./scripts/confirm-shutdown.sh;
    executable = true;
  };

 xdg.configFile."waybar/scripts/power-icon.sh" = {
    source = ./scripts/power-icon.sh;
    executable = true;
  };
  
 xdg.configFile."waybar/scripts/confirm-reboot.sh" = {
    source = ./scripts/confirm-reboot.sh;
    executable = true;
  };

  programs.waybar = {
    enable = true;

     # ⬅️ აქ არის მთავარი ფიქსი
    style = ./style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "clock"
        ];

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
          "custom/separator"
          "custom/power"
        ];

        clock = {
          format = "{:%Y-%m-%d %H:%M:%S}";
          tooltip = true;
        };

        cpu = {
          format = " {usage}%";
          interval = 2;
        };

        memory = {
          format = " {used}/{total}MB";
          interval = 2;
        };

        network = {
          format-wifi = "";
          format-ethernet = "";
          format-disabled = "✈";
          format-disconnected = "";
          tooltip = true;

          tooltip-format-wifi = "SSID: {essid}\nSignal: {signalStrength}%";
          tooltip-format-ethernet = "IP: {ipaddr}";

          on-click = "~/.config/waybar/scripts/wifi-menu.sh";
        };

        "custom/separator" = {
          format = "|";
          tooltip = false;
        };

        "custom/kbd" = {
          exec = "~/.config/waybar/scripts/kbdc.sh";
          interval = 1;
          return-type = "json";
          on-click = "~/.config/waybar/scripts/kbd-togle.sh";
          tooltip = "Click to switch language";
        };

        "custom/power" = {

          exec = "~/.config/waybar/scripts/power-icon.sh";
          interval = 1;
          return-type = "json";
 
          # მარცხენა კლიკი → გამორთვა
          on-click = "systemctl poweroff";

          # მარჯვენა კლიკი → გადატვირთვა
          on-click-right = "systemctl reboot";
        };

        pulseaudio = {
          format = "  {volume}%";
          format-muted = " Muted";
          on-click = "pavucontrol";
        };

        battery = {
          bat = "BAT0";
          interval = 30;

          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };

          format = "{icon}";
          format-charging = "🔌 {icon}";
          format-full = "🔋 ";
          format-icons = [ "" "" "" "" "" ];
          tooltip = true;
        };
      };
    };
  };
}

