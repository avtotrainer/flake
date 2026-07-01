{ config, pkgs, ... }:

{
  # CUPS — system printing service
  services.printing = {
    enable = true;

    drivers = [
      pkgs.hplip
      pkgs.cups-filters
    ];
  };

  # Avahi — network printer discovery via mDNS/DNS-SD
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Firewall — IPP/CUPS
  networking.firewall.allowedTCPPorts = [ 631 ];

  # Declarative printer definition
  hardware.printers = {
    ensureDefaultPrinter = "HP_M102w";

    ensurePrinters = [
      {
        name = "HP_M102w";
        location = "Wi-Fi";
        deviceUri = "ipp://192.168.0.5/ipp/print";
        model = "everywhere";

        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
  };
}
