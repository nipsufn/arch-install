#!/bin/bash

timedatectl set-ntp true
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
sed -i 's/#\[multilib\]/[multilib]/g' /etc/pacman.conf
sed -i '/^\[multilib\]$/,+1 s.^#..' /etc/pacman.conf
pacstrap /mnt base linux linux-firmware e2fsprogs exfat-utils dosfstools ntfs-3g vim man-db man-pages textinfo base-devel grub intel-ucode cpupower alsa-utils alsa-oss screen tree git openssh xorg xorg-apps xorg-xinit xdotool xbindkeys cinnamon networkmanager steam code firefox telegram-desktop keepassxc atril eom gimp blender vlc clementine mate-terminal tilda nemo-fileroller nemo-preview nemo-share gvfs-mtp gvfs-gphoto2 gvfs-afc gvfs-smb ttf-dejavu noto-fonts ttf-liberation ttf-freefont
#  nvidia nvidia-utils lib32-nvidia-utils
#  xf86-video-ati mesa lib32-mesa xf86-input-libinput
genfstab -U /mnt >> /mnt/etc/fstab
cd /mnt
curl -fOsS https://raw.githubusercontent.com/nipsufn/arch-install/master/arch-postinstall.sh
chmod 0755 arch-postinstall.sh
cd
arch-chroot /mnt /arch-postinstall.sh
