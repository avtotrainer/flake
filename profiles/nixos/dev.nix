{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs_20
    go
    neovim
    vscode
    gh
    zoxide
    google-chrome
  ];
}

