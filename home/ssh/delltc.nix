{ lib, osConfig, ... }:

let
  isLaptop = osConfig.networking.hostName == "laptop";
in
{
  programs.ssh = lib.mkIf isLaptop {
    enable = true;

    matchBlocks = {
      "delltc-ts" = {
        hostname = "100.115.119.72";
        user = "avto";
        identityFile = "~/.ssh/id_ed25519_din_recovery";
        identitiesOnly = true;

        extraOptions = {
          PreferredAuthentications = "publickey";
          PasswordAuthentication = "no";
          KbdInteractiveAuthentication = "no";
        };
      };

      "delltc-lan" = {
        hostname = "192.168.0.203";
        user = "avto";
        identityFile = "~/.ssh/id_ed25519_din_recovery";
        identitiesOnly = true;
      };

      "inu" = {
      hostname = "130.61.116.60"; # რეალური IP მისამართი
      user = "ubuntu";
      identityFile = "~/.ssh/id_rsa"; # თქვენი SSH Key-ს მისამართი
      };
      
      "*" = {
      serverAliveInterval = 30;
      serverAliveCountMax = 3;
      };
    };
  };
}
