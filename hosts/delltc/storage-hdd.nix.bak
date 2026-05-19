{ ... }:

{
  ##################################################
  # DELLTC LOCAL HDD STORAGE
  #
  # ეს დისკი ეკუთვნის მხოლოდ delltc host-ს.
  # ამიტომ კონფიგურაცია ინახება host-ის შიგნით,
  # არა საერთო modules/nixos-ში.
  ##################################################

  systemd.tmpfiles.rules = [
    "d /srv/storage 0755 root root - -"
  ];

  fileSystems."/srv/storage" = {
    device = "/dev/disk/by-uuid/90d2f1fa-faf8-4517-9088-e98e3ea8886a";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
    ];
  };
}
