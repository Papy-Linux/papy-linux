# Needed for internet in baseline
# https://gitlab.archlinux.org/archlinux/archiso/-/issues/160
echo 'Setting up network...'
systemctl start systemd-networkd
systemctl start dhcpcd
systemctl start pacman-init
systemctl start reflector
echo
