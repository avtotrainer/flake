{ config, pkgs, lib, ... }:

{
  ##################################################
  # WAYLAND-ONLY SYSTEM
  #
  # Xorg მთლიანად გამორთულია.
  # სისტემა მუშაობს მხოლოდ Wayland-ზე.
  ##################################################
  services.xserver.enable = false;

  ##################################################
  # HYPRLAND (Wayland compositor)
  #
  # Hyprland ჩაირთვება როგორც გრაფიკული სესია,
  # რომელსაც მართავს display manager (SDDM).
  ##################################################
  programs.hyprland.enable = true;

  ##################################################
  # DISPLAY MANAGER — SDDM (Wayland)
  #
  # რატომ SDDM:
  # - systemd-logind სრული ინტეგრაცია
  # - PAM-based login
  # - systemd --user lifecycle
  # - graphical-session.target ავტომატური აქტივაცია
  #
  # მნიშვნელოვანია:
  # - Hyprland უნდა გაეშვას SDDM-ის მიერ
  # - არ უნდა არსებობდეს parallel/manual launch
  ##################################################
  services.displayManager.sddm = {
    enable = true;

    # Wayland backend SDDM-ისთვის
    wayland.enable = true;
  };

  ##################################################
  # DEFAULT GRAPHICAL SESSION
  #
  # SDDM-ს ეუბნება, რომ ავტორიზაციის შემდეგ
  # უნდა გაეშვას Hyprland სესია.
  ##################################################
  services.displayManager.defaultSession = "hyprland";

  ##################################################
  # AUTOLOGIN (SDDM-ით, არა TTY-დან)
  #
  # შედეგი:
  # - არ ჩანს login screen
  # - მაგრამ login მაინც ხდება PAM-ის გზით
  # - systemd --user სესია სრულად სწორად ირთვება
  ##################################################
  services.displayManager.autoLogin = {
    enable = true;
    user = "avto";
  };

  ##################################################
  # IMPORTANT GUARANTEE
  #
  # greetd არ არის გამოყენებული.
  # არც enable=true, არც enable=false.
  #
  # ეს ნიშნავს:
  # - სისტემაში არსებობს მხოლოდ ერთი DM: SDDM
  # - არ არის კონფლიქტი session lifecycle-ში
  ##################################################
}

