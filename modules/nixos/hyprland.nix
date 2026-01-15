{
  services.xserver.enable = false;

  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "Hyprland";
      user = "avto";
    };
  };
}

