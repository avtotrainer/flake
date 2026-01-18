{ pkgs, ... }:

{
  ##################################################
  # GRAPHICAL SESSION BRIDGE (SDDM AUTOLOGIN)
  #
  # რატომ არის საჭირო:
  # - sddm-autologin სესია systemd-სთვის
  #   ავტომატურად არ ითვლება "graphical session"-ად
  # - ამიტომ graphical-session.target არ აქტიურდება
  #
  # რას აკეთებს ეს service:
  # - ერთხელ ეშვება user session-ის დაწყებისას
  # - systemd-ს ეუბნება:
  #   "გრაფიკული სესია აქტიურია"
  #
  # რას არ აკეთებს:
  # - არ უშვებს Waybar-ს
  # - არ უშვებს Hyprland-ს
  # - არ არღვევს systemd lifecycle-ს
  ##################################################
  systemd.user.services.graphical-session-bridge = {
    ##################################################
    # UNIT
    ##################################################
    Unit = {
      Description = "Activate graphical-session.target (SDDM autologin bridge)";
    };

    ##################################################
    # SERVICE
    ##################################################
    Service = {
      Type = "oneshot";

      # პირდაპირ და მკაფიო სიგნალი systemd-სთვის
      ExecStart =
        "${pkgs.systemd}/bin/systemctl --user start graphical-session.target";
    };

    ##################################################
    # INSTALL
    ##################################################
    Install = {
      # user session-ის დაწყებისას ერთხელ გაეშვება
      WantedBy = [ "default.target" ];
    };
  };
}

