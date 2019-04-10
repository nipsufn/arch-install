#!/bin/bash

timedatectl set-ntp true
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
sed -i 's/#\[multilib\]/[multilib]/g' /etc/pacman.conf
sed -i '/^\[multilib\]$/,+1 s.^#..' /etc/pacman.conf
pacstrap /mnt base base base-devel grub xorg xorg-apps xorg-xinit xdtool xbindkeys cinnamon networkmanager steam code firefox telegram-desktop syncthing-gtk keepassxc atril eom gimp blender vlc clementine mate-terminal tilda nemo-fileroller nemo-preview nemo-share gvfs-mtp gvfs-gphoto2 gvfs-afc gvfs-smb ntfs-3g intel-ucode cpupower alsa-utils alsa-oss zsh zsh-completions zsh-theme-powerlevel9k powerline-fonts screen tree git openssh ttf-dejavu noto-fonts ttf-liberation ttf-freefont
#  nvidia nvidia-utils lib32-nvidia-utils
#  xf86-video-ati mesa lib32-mesa xf86-input-libinput
genfstab -U /mnt >> /mnt/etc/fstab
cd /mnt/root
wget https://raw.githubusercontent.com/nipsufn/arch-install/master/arch-postinstall.sh
cd
arch-chroot /mnt /root/arch-postinstall.sh
