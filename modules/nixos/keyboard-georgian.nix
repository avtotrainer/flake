{ ... }:

{
  services.xserver.xkb = {
    layout = "us,ge-custom";
    variant = ",ergonomic";
    options = "grp:win_space_toggle";

    extraLayouts.ge-custom = {
      description = "Georgian ergonomic with Mtavruli on Shift";
      languages = [ "kat" ];
      symbolsFile = ./xkb/ge-custom;
    };
  };

  console.useXkbConfig = true;
}
