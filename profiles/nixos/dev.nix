{ pkgs, lib, config, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      # CLI — სისტემაშიც შეიძლება
      gh
    ]
    ++ lib.optionals (!config.wsl.enable) [
      # GUI — ლეპტოპზე დარჩეს System Layer-ში
      vscode
      google-chrome
    ];
}

