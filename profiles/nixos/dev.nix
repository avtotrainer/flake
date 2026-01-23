{ pkgs, lib, config, ... }:

let
  isWSL = (config ? wsl) && (config.wsl.enable or false);
in
{
  environment.systemPackages =
    with pkgs;
    [
      # CLI
      gh
    ]
    ++ lib.optionals (!isWSL) [
      # GUI — ლეპტოპზე დარჩეს System Layer-ში
      vscode
      google-chrome
    ];
}

