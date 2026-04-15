{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-tty
  ];

  programs.gnupg.agent = {
    enable = true;
  };
}
