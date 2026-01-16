{
  # Wayland-only სისტემა
  services.xserver.enable = false;

  # Hyprland compositor
  programs.hyprland.enable = true;

  # greetd — session launcher ლოგინ სქრინის გარეშე
  services.greetd = {
    enable = true;

    settings = {
      # ავტომატურად იწყებს Hyprland-ს,
      # არანაირი greeter, არანაირი UI
      initial_session = {
        command = "hyprland";
        user = "avto";
      };
    };
  };
}

