# profiles/nixos/dev.nix
{ pkgs, lib, config, ... }:

let
  # უსაფრთხო შემოწმება: თუ wsl მოდული საერთოდ არ არის, false იქნება.
  isWsl = lib.attrByPath [ "wsl" "enable" ] false config;
in
{
  environment.systemPackages = with pkgs; [
    nodejs_20
    go
    gh
    zoxide
  ]
  # GUI — ლეპტოპზე დარჩეს System Layer-ში, WSL-ზე არ გვჭირდება (Windows-ში გაქვს).
  ++ lib.optionals (!isWsl) [
    vscode
    google-chrome
  ];
}

