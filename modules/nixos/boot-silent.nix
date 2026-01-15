{
  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 1;
      editor = false;
    };
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0;

    initrd.verbose = false;
    consoleLogLevel = 0;

    kernelParams = [
      "quiet"
      "loglevel=0"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "udev.log_level=0"
      "vt.global_cursor_default=0"
    ];

    plymouth.enable = true;
    plymouth.theme = "spinner";

    kernelModules = [ "btusb" ];
    extraModprobeConfig = "options ideapad_laptop bluetooth=1";
  };
}

