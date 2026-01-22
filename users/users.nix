{ pkgs, ... }:

{
  users.users.avto = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}

