{ pkgs, ... }:

{
  programs.zsh.enable = true;

  programs.zsh.interactiveShellInit = ''
    eval "$(zoxide init zsh --cmd z)"
  '';
}

