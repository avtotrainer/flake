{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  programs.ssh.startAgent = true;
}

