{ pkgs, ... }:

{
  users.users.avto = {
    isNormalUser = true;

    # კრიტიკული WSL-ისთვის (სტაბილური uid)
    uid = 1000;

    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}

