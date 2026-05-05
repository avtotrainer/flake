{ config, lib, ... }:

{
  networking = {
    networkmanager.enable = true;
    wireless.enable = lib.mkForce false;
  };

  environment.etc."NetworkManager/system-connections/MES.nmconnection" = {
    mode = "0600";
    text = ''
      [connection]
      id=MES
      type=wifi
      autoconnect=true

      [wifi]
      ssid=MES
      mode=infrastructure

      [wifi-security]
      key-mgmt=wpa-eap

      [802-1x]
      eap=peap;
      identity=apangani@emis.ge
      password=@/run/secrets/mes-wifi-pass
      phase2-auth=mschapv2

      [ipv4]
      method=auto

      [ipv6]
      method=auto
    '';
  };
}

