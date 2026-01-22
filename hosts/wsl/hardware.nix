{ config, lib, pkgs, ... }:

{
  boot.isContainer = true;

  # systemd შეზღუდულ რეჟიმში
  systemd.enableUnifiedCgroupHierarchy = false;
}

