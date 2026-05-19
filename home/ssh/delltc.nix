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
    };
  };
}
