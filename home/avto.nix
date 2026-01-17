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
    ./systemd/graphical-session-bridge.nix
    ./systemd/waybar.nix
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
  # WAYBAR — systemd user service (სწორი გზა)
  ##################################################
  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };

  ##################################################
  # GRAPHICAL SESSION MARKER (აკლებული რგოლი)
  #
  # ეს unit არაფერს უშვებს გრაფიკულად.
  # ის უბრალოდ systemd-ს ეუბნება:
  # "graphical session უკვე არსებობს".
  ##################################################
  systemd.user.services.graphical-session-marker = {
    Unit = {
      Description = "Mark graphical session as active";
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
  programs.git.enable = true;

  ##################################################
  # REQUIRED BY HOME-MANAGER
  ##################################################
  home.stateVersion = "25.11";
}

