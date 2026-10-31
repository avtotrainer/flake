# modules/nixos/overlays.nix
# სისტემური overlay-ები. Home Manager იყენებს useGlobalPkgs = true-ს,
# ამიტომ overlay აქ (System Layer-ში) უნდა იყოს — HM-ის nixpkgs.overlays იგნორირდება.
{ inputs, ... }:

{
  nixpkgs.overlays = [
    # pkgs.claude-code → sadjow/claude-code-nix (ყოველთვის ახალი ვერსია)
    inputs.claude-code.overlays.default
  ];
}
