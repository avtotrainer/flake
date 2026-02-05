{ config, pkgs, ... }:

{
  # CUPS — system printing service
  services.printing = {
    enable = true;

    drivers = [
      pkgs.hplip
    ];
  };

  # Network printer discovery (სავალდებულო, თორემ IP პრინტერი „უჩინარი“ იქნება)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Firewall — IPP (631)
  networking.firewall.allowedTCPPorts = [ 631 ];
}

