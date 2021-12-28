echo 'Setting up network...'
systemctl start systemd-networkd
systemctl start dhcpcd
systemctl start pacman-init
systemctl start reflector
echo
