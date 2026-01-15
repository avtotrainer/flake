{ pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  services.blueman.enable = true;

  systemd.services.rfkill-unblock-bluetooth = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart =
      "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
  };
}

