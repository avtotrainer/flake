{ pkgs, ... }:

{
  ##################################################
  # HYPRLAND → GRAPHICAL SESSION BRIDGE
  #
  # რას აკეთებს:
  # - როცა Hyprland session მზად არის
  # - systemd-ს ეუბნება, რომ graphical-session აქტიურია
  #
  # რას არ აკეთებს:
  # - არაფერს უშვებს
  # - არაფერს აჩენს ეკრანზე
  ##################################################
  systemd.user.services.hyprland-graphical-session = {
    Unit = {
      Description = "Activate graphical-session.target for Hyprland";

      # Hyprland session უნდა არსებობდეს
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
    };

    Service = {
      Type = "oneshot";

      # systemd-ს ვეუბნებით:
      # „გრაფიკული სესია დაწყებულია“
      ExecStart =
        "${pkgs.systemd}/bin/systemctl --user start graphical-session.target";
    };

    Install = {
      # Hyprland-ის ჩატვირთვაზე ავტომატურად ეშვება
      WantedBy = [ "hyprland-session.target" ];
    };
  };
}

