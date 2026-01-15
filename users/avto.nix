{ pkgs, ... }:

{
  users.users.avto = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  programs.zsh.interactiveShellInit = ''
    eval "$(zoxide init zsh --cmd z)"
  '';
}

