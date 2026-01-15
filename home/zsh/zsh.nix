{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "z"
      ];
    };

    initContent = ''
      # Powerlevel10k theme (standalone)
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # User-selected prompt config (managed by Home Manager)
      source ~/.p10k.zsh
    '';
  };

  home.packages = with pkgs; [
    zsh-powerlevel10k
    zoxide
  ];

  home.file.".p10k.zsh".source = ./p10k.zsh;
}
