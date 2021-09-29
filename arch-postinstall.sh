#!/bin/bash
USER="nemo"

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
mkinitcpio -p linux
systemctl enable NetworkManager
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
sed -i 's/#\[multilib\]/[multilib]/g' /etc/pacman.conf
sed -i '/^\[multilib\]$/,+1 s.^#..' /etc/pacman.conf
useradd -m -s /bin/zsh $USER
usermod -aG wheel,users,games,uucp,audio,disk,floppy,input,kvm,optical,scanner,storage,video,network,power $USER
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers

cd /home/$USER

sudo -u $USER curl -fOsS https://codeload.github.com/nipsufn/arch-install/zip/master
sudo -u $USER bash -c 'shopt -s dotglob && unzip master arch-install-master/skel/* && mv arch-install-master/skel/* ./ && rmdir -p arch-install-master/skel && shopt -u dotglob'
sudo -u $USER rm master
