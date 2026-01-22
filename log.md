❯ git add users/avto.nix
❯ git commit -m "Fix users/avto.nix syntax after user split"
[main f571fdf] Fix users/avto.nix syntax after user split
 1 file changed, 8 deletions(-)
❯ sudo nixos-rebuild switch --flake .#laptop
[sudo] password for avto:
building the system configuration...
stopping the following units: NetworkManager.service, systemd-modules-load.service, systemd-tmpfiles-resetup.service, tlp.service, wpa_supplicant.service
activating the configuration...
reviving group 'dhcpcd' with GID 989
removing group ‘nm-openvpn’
removing group ‘networkmanager’
reviving user 'dhcpcd' with UID 992
removing user ‘nm-openvpn’
removing user ‘nm-iodine’
setting up /etc...
removing obsolete symlink ‘/etc/ipsec.secrets’...
removing obsolete symlink ‘/etc/NetworkManager/NetworkManager.conf’...
removing obsolete symlink ‘/etc/NetworkManager/dispatcher.d/99tlp-rdw-nm’...
reloading user units for avto...
restarting sysinit-reactivation.target
reloading the following units: dbus-broker.service
restarting the following units: polkit.service, systemd-udevd.service
starting the following units: systemd-modules-load.service, systemd-tmpfiles-resetup.service, tlp.service
the following new units were started: dhcpcd.service
Done. The new configuration is /nix/store/pwik9pzjmyk8pfsbq35bslic6lx8gdxs-nixos-system-nixos-25.11.20260117.72ac591
