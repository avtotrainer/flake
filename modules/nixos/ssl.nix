{ ... }:

{
  environment.variables = {
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  };

  nix.settings = {
    ssl-cert-file = "/etc/ssl/certs/ca-certificates.crt";
  };

  security.pki.certificateFiles = [
    ./certs/School_wifi.cer
  ];
}
