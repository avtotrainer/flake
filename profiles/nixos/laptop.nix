{ ... }:

{
  # Laptop-specific defaults (არა hardware)
  services.upower.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "poweroff";
    HandleLidSwitchExternalPower = "poweroff";
    HandleLidSwitchDocked = "poweroff";
    HandlePowerKey = "poweroff";
    HandlePowerKeyLongPress = "poweroff";
  };
}

