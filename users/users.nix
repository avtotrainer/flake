{ pkgs, ... }:

{
  users.users.avto = {
    isNormalUser = true;

    # ── კრიტიკული WSL-ისთვის ─────────────────────────
    uid = 1000;
    initialPassword = "2";
    # -------------------------------------------------

    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
}

