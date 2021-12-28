#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="papylinux"
iso_label="PAPYLINUX_$(date +%Y%m)"
iso_publisher="Papy Linux"
iso_application="Papy Linux"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="erofs"
airootfs_image_tool_options=('-zlz4hc,12')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/usr/local/bin/setup"]="0:0:755"
)
