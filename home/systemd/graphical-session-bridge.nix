{ pkgs, ... }:

{
  ##################################################
  # HYPRLAND → GRAPHICAL SESSION BRIDGE
  #
  # როლი:
  # - systemd-ს ეუბნება, რომ გრაფიკული სესია აქტიურია
  #
  # მნიშვნელოვანი:
  # - Hyprland თვითონ არ ააქტიურებს systemd target-ებს
  # - ამიტომ საჭიროა ეს bridge service
  ##################################################
  systemd.user.services.hyprland-graphical-session = {
    ##################################################
    # UNIT
    ##################################################
    Unit = {
      Description = "Activate graphical-session.target (Hyprland bridge)";

      # ⚠️ შეცვლილია:
      # ადრე იყო მიბმული hyprland-session.target-ზე,
      # რომელიც systemd-ში რეალურად არ არსებობს.
      #
      # ახლა Unit-ს არ აქვს დამოკიდებულებები —
      # ეს service უბრალოდ trigger-ია.
    };

    ##################################################
    # SERVICE
    ##################################################
    Service = {
      # oneshot — ერთხელ უნდა გაეშვას და დასრულდეს
      Type = "oneshot";

      # systemd-ს ვეუბნებით:
      # „გრაფიკული სესია დაწყებულია“
      ExecStart =
        "${pkgs.systemd}/bin/systemctl --user start graphical-session.target";
    };

    ##################################################
    # INSTALL
    ##################################################
    Install = {
      # ⚠️ შეცვლილია:
      # ადრე: WantedBy = hyprland-session.target (არარსებული)
      #
      # ახლა:
      # - ებმება default.target-ზე
      # - user session-ის დაწყებისას ავტომატურად გაეშვება
      WantedBy = [ "default.target" ];
    };
  };
}

