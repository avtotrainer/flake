{ ... }:

{
  services.xserver.xkb = {
    layout = "us,ge,ge-ergonomic-mtavruli";
    variant = ",ergonomic,";
    options = "grp:win_space_toggle";

    extraLayouts.ge-ergonomic-mtavruli = {
      description = "Georgian (ergonomic, Mtavruli)";
      languages = [ "kat" ];
      symbolsFile = ./xkb/ge-ergonomic-mtavruli;
    };
  };

  console.useXkbConfig = true;
}
