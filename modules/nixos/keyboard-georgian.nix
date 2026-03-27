{ ... }:

{
  services.xserver.xkb = {
    layout = "us,ge-custom";
    variant = ",";
    options = "grp:win_space_toggle";

    extraLayouts.ge-custom = {
      description = "Georgian ergonomic with Mtavruli";
      languages = [ "kat" ];
      symbolsFile = ./xkb/symbols/ge-custom;
    };
  };

  console.useXkbConfig = true;
}
