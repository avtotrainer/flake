{ config, pkgs, lib, ... }:

{
  ##################################################
  # XSERVER INFRASTRUCTURE (REQUIRED FOR SDDM)
  #
  # მნიშვნელოვანია:
  # - ეს არ ნიშნავს, რომ Xorg სესია გამოიყენება
  # - ეს ნიშნავს, რომ display manager-ს (SDDM)
  #   აქვს სრული systemd-logind / PAM ინფრასტრუქტურა
  #
  # თუ ეს falseა:
  # - SDDM ვერ ქმნის სრულფასოვან graphical session-ს
  # - graphical-session.target არ აქტიურდება
  ##################################################
  services.xserver.enable = true;

  ##################################################
  # HYPRLAND (WAYLAND COMPOSITOR)
  #
  # Hyprland რეგისტრირდება როგორც Wayland session,
  # რომელსაც display manager გამოიყენებს.
  ##################################################
  programs.hyprland.enable = true;

  ##################################################
  # DISPLAY MANAGER — SDDM (WAYLAND MODE)
  #
  # როლი:
  # - ახორციელებს login-ს (PAM)
  # - ააქტიურებს systemd --user სესიას
  # - systemd-logind-ის მეშვეობით
  #   ავტომატურად რთავს graphical-session.target-ს
  ##################################################
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  ##################################################
  # DEFAULT GRAPHICAL SESSION
  #
  # SDDM-ს ვეუბნებით:
  # "ავტორიზაციის შემდეგ გაუშვი Hyprland"
  ##################################################
  services.displayManager.defaultSession = "hyprland";

  ##################################################
  # AUTOLOGIN (SDDM-ით, არა TTY-დან)
  #
  # შედეგი:
  # - ეკრანი პირდაპირ შედის Hyprland-ში
  # - მაგრამ login მაინც ხდება სწორად:
  #   PAM → systemd-logind → systemd --user
  ##################################################
  services.displayManager.autoLogin = {
    enable = true;
    user = "avto";
  };

  ##################################################
  # SESSION REGISTRATION FOR SDDM
  #
  # NixOS 26.05+:
  # - sessionPackages გადატანილია services.displayManager ქვეშ
  #
  # ეს უზრუნველყოფს, რომ:
  # - hyprland.desktop რეალურად არსებობს
  # - SDDM ხედავს Hyprland-ს როგორც session-ს
  ##################################################
  services.displayManager.sessionPackages = [
    pkgs.hyprland
  ];

  ##################################################
  # GUARANTEES / CONSTRAINTS
  #
  # - greetd არ გამოიყენება
  # - exec-once არ გამოიყენება
  # - graphical-session bridge არ არსებობს
  #
  # systemd მთლიანად მართავს lifecycle-ს:
  # graphical-session.target → waybar.service
  ##################################################
}

