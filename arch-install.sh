#!/bin/bash
USER="nemo"
timedatectl set-ntp true
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
sed -i 's/#\[multilib\]/[multilib]/g' /etc/pacman.conf
sed -i '/^\[multilib\]$/,+1 s.^#..' /etc/pacman.conf
pacstrap /mnt base base base-devel grub xorg xorg-apps xorg-xinit cinnamon networkmanager steam code firefox telegram-desktop syncthing-gtk keepassxc atril eom gimp blender vlc clementine mate-terminal tilda nemo-fileroller nemo-preview nemo-share gvfs-mtp gvfs-gphoto2 gvfs-afc gvfs-smb ntfs-3g intel-ucode cpupower alsa-utils alsa-oss zsh zsh-completions zsh-theme-powerlevel9k powerline-fonts screen tree git openssh ttf-dejavu noto-fonts ttf-liberation ttf-freefont
#  nvidia nvidia-utils lib32-nvidia-utils
#  xf86-video-ati mesa lib32-mesa xf86-input-libinput
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
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
useradd -s /bin/zsh $USER
usermod -aG wheel,users,games,uucp,audio,disk,floppy,input,kvm,optical,scanner,storage,video,network,power $USER
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers

sudo su $USER
cd
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -s /usr/share/zsh-theme-powerlevel9k /$USER/home/.oh-my-zsh/custom/themes/powerlevel9k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel9k/powerlevel9k"/g' /home/$USER/.zshrc
#sed -i '1iexport TERM="xterm-256color"' /home/$USER/.zshrc
#sed -i '1iexport LANG="en_US.UTF-8"' /home/$USER/.zshrc

wget https://raw.githubusercontent.com/nipsufn/arch-install/master/.screenrc
wget https://raw.githubusercontent.com/nipsufn/arch-install/master/.startup.sh

printf "\n~/.startup.sh\n" >> .zshrc