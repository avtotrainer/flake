{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      dejavu_fonts
      nerd-fonts.hack
      nerd-fonts.symbols-only
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif Georgian" "Noto Serif" ];
      sansSerif = [ "Noto Sans Georgian" "Noto Sans" ];
      monospace = [ "Hack Nerd Font Mono" ];
    };
  };
}

