{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # oh-my-zsh მხოლოდ plugins-ებისთვის (არანაირი theme)
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "z"
      ];
    };

    # Powerlevel10k — standalone, declarative
    initContent = ''
      # Powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # User-selected prompt config (from repo)
      source ~/.p10k.zsh
    '';
  };

  # Required packages
  home.packages = with pkgs; [
    zsh-powerlevel10k
    zoxide
  ];

  # Ensure p10k config is owned by Home Manager
  home.file.".p10k.zsh".source = ./p10k.zsh;
}
