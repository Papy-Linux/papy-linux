#!/bin/bash

# Quit if UEFI
# if [[ -d /sys/firmware/efi/efivars ]]; then
#     echo "UEFI isn't supported yet, please boot in BIOS mode."
#     exit
# fi

echo

# Warning
echo 'THIS WILL ERASE ALL DATA ON YOUR DISK'
echo
echo 'Additionnally, this is still in early developement and very likely to break things on your computer, or not to work.'
echo
echo -n 'Proceed? [y/N] '
read proceed
if [[ $proceed != "y" ]]; then
    exit
fi
echo

# Prompts
echo -en 'What is your keyboard layout? (example: en) \n> '
read klayout
loadkeys $klayout
echo

lsblk
echo

echo -en 'What disk will you use? (example: /dev/sda) \n> '
read disk
echo

echo -en 'What is your locale? (example: en_US) \n> '
read locale
echo

echo -en 'What is your timezone? (example: Europe/Paris) \n> '
read timezone
echo

username="user"

# Enable ntp
echo "Enabling ntp"
timedatectl set-ntp true

# Configure disk
if [[ -d /sys/firmware/efi/efivars ]]; then
    parted -s $disk \
        mklabel gpt \
        mkpart 'EFI' fat32 1MiB 501MiB \
        mkpart 'swap' linux-swap 501MiB 4501MiB \
        mkpart 'root' ext4 4501MiB 100% \
        || exit
    mkfs.fat -F 32 ${disk}1 || exit
    mkswap ${disk}2 || exit
    mkfs.ext4 -F ${disk}3 || exit
    mount ${disk}3 /mnt || exit
    swapon ${disk}2 || exit
    mkdir /mnt/efi || exit
    mount ${disk}1 /mnt/efi || exit
else
    parted -s $disk \
        mklabel msdos \
        mkpart primary 1MiB 4096MiB \
        mkpart primary 4096MiB 100% \
        || exit
    mkswap ${disk}1 || exit
    mkfs.ext4 -F ${disk}2 || exit
    swapon ${disk}1
    mount ${disk}2 /mnt || exit
fi

# Install system
echo "Installing everything (pactstrap)"
yes | pacstrap /mnt \
    base base-devel linux linux-firmware grub \
    xorg-server xorg-xinit i3 xdotool polkit ttf-dejavu \
    xterm firefox \
    python python-pip \
    dhcpcd numlockx git python picom \
    || exit

# Install cfs zen tweaks
arch-chroot /mnt bash -c '
cd /tmp
git clone https://aur.archlinux.org/cfs-zen-tweaks
chown -R nobody cfs-zen-tweaks
cd cfs-zen-tweaks
su nobody -s /bin/bash -c makepkg
yes | pacman -U *.tar.zst
systemctl enable --now cfs-zen-tweaks
'

# Install polybar
echo "Installing polybar"
install polybar.tar.zst /mnt/
yes | arch-chroot /mnt pacman -U /polybar.tar.zst
rm /mnt/polybar.tar.zst

# Install Material Icons
mkdir -p /mnt/usr/share/fonts/TTF
curl -o /mnt/usr/share/fonts/TTF/MaterialIcons-Regular.ttf 'https://raw.githubusercontent.com/google/material-design-icons/master/font/MaterialIcons-Regular.ttf'

# Install human cursor theme
arch-chroot /mnt bash -c '
cd /tmp
git clone https://aur.archlinux.org/xcursor-human
chown -R nobody xcursor-human
cd xcursor-human
su nobody -s /bin/bash -c makepkg
yes | pacman -U *.tar.zst
'

# Config files
echo "Installing configuration files"
(cd rootfs ; find -type f -exec install -D {} /mnt/{} \;)

# Fstab
echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab || exit

# Timezone
echo "Setting timezone"
arch-chroot /mnt ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
# Language
echo "Setting locales"
echo "en_US UTF-8
$locale UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=${locale}.UTF-8" > /mnt/etc/locale.conf
# Keyboard layout
echo "Setting keyboard layout"
echo "KEYMAP=$klayout" > /mnt/etc/vconsole.conf

# Bootloader
if [[ -d /sys/firmware/efi/efivars ]]; then
    yes | arch-chroot /mnt pacman -S efibootmgr
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/efi || exit
else
    arch-chroot /mnt grub-install --target=i386-pc $disk || exit
fi
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg || exit

# Root password
echo -e "root\nroot" | arch-chroot /mnt passwd root

# Create user
echo "Creating the user"
arch-chroot /mnt useradd -m -G wheel -p $(openssl passwd -1 "$pass") user || exit
echo -e "user\nuser" | arch-chroot /mnt passwd user

# Xorg keyboard layout
echo "Setting X keyboard layout"
mkdir -p /mnt/etc/X11/xorg.conf.d/
echo "Section \"InputClass\"
        Identifier \"system-keyboard\"
        MatchIsKeyboard \"on\"
        Option \"XkbLayout\" \"$klayout\"
EndSection" > /mnt/etc/X11/xorg.conf.d/00-keyboard.conf

# Enable network service dhcpcd
echo "Setting up network"
arch-chroot /mnt systemctl enable dhcpcd

# Installation finished
echo '
    Installation finished.

    You may type `reboot` to reboot your computer on the installed OS.
    You can as well type `arch-chroot /mnt` if you need to modify things on the system before booting it.

    Tip: to debug, you can open a terminal on the system with Win+Shift+T.

    Enjoy Papy Linux!
'