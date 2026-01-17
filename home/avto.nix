{ pkgs, osConfig, ... }:

{
  ##################################################
  # USER BASICS
  ##################################################
  home.username = "avto";
  home.homeDirectory = "/home/avto";

  ##################################################
  # SESSION VARIABLES
  ##################################################
  home.sessionVariables = {
    HOSTNAME_FROM_FLAKE = osConfig.networking.hostName;

    EDITOR = "nvim";
    VISUAL = "nvim";
    NVIM_APPNAME = "nvim";
  };

  ##################################################
  # IMPORTS
  ##################################################
  imports = [
    ./zsh/zsh.nix
    ./config/config.nix
  ];

  ##################################################
  # PACKAGES
  ##################################################
  home.packages = with pkgs; [
    git
    neovim
    jq
  ];

  ##################################################
  # WAYBAR
  # - კონფიგი: Home Manager
  # - გაშვება: systemd user service (არა exec-once)
  ##################################################
  programs.waybar = {
    enable = true;

    # HM არ ქმნის საკუთარ waybar.service-ს
    # (Waybar უკვე systemd user service-ად გაქვს გააზრებული)
    systemd.enable = false;
  };

  ##################################################
  # GRAPHICAL SESSION FIX (DM გარეშე)
  #
  # ეს არის აკლებული რგოლი:
  # - user systemd-ს ვეუბნებით, რომ graphical session დაიწყო
  # - შედეგად ირთვება graphical-session.target
  # - და Waybar-ის systemd service სტარტდება ნორმალურად
  ##################################################
  systemd.user.services.graphical-session-fix = {
    Unit = {
      Description = "Activate graphical-session.target (no DM)";
      After = [ "default.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart =
        "${pkgs.systemd}/bin/systemctl --user start graphical-session.target";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  ##################################################
  # GIT
  ##################################################
  programs.git = {
    enable = true;
    settings = {
      user.name = "avto";
      user.email = "avto@example.com";
    };
  };

  ##################################################
  # REQUIRED BY HOME-MANAGER
  ##################################################
  home.stateVersion = "25.11";
}

