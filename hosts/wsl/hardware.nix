{ config, lib, pkgs, ... }:

{
  # ----------------------------------------
  # WSL hardware abstraction
  # ----------------------------------------

  # WSL არ არის რეალური hardware
  boot.isContainer = true;

  # systemd cgroup v2 გამოიყენება დეფოლტად (არ ვეხებით)
  # systemd.enableUnifiedCgroupHierarchy — REMOVED (obsolete)

  # Clock / RTC irrelevant WSL-ში
  time.hardwareClockInLocalTime = false;

  # Console / kernel noise მინიმუმამდე
  boot.kernel.sysctl = {
    "kernel.printk" = "3 3 3 3";
  };
}

