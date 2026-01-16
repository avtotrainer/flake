{ pkgs, ... }:

{
  services.xserver.enable = false;

  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "tuigreet --cmd hyprland";
        user = "avto";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    tuigreet
  ];
}

