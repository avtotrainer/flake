{ ... }:

{
  ##################################################
  # STORAGE HDD — delltc only
  ##################################################

  fileSystems."/srv/storage" = {
    device = "/dev/disk/by-uuid/90d2f1fa-faf8-4517-9088-e98e3ea8886a";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
    ];
  };

  ##################################################
  # STORAGE ACCESS GROUP
  ##################################################

  users.groups.storage = {};

  users.users.avto.extraGroups = [
    "storage"
  ];

  ##################################################
  # STORAGE DIRECTORY PERMISSIONS
  ##################################################

  systemd.tmpfiles.rules = [
    "d /srv/storage 2770 root storage - -"
  ];
}
