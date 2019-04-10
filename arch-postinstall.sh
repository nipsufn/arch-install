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

sudo -u $USER curl -fOsS https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sed -i 's/env zsh -l//g' install.sh
chmod 0755 install.sh
sudo -u $USER ./install.sh
rm install.sh

sudo -u $USER ln -s /usr/share/zsh-theme-powerlevel9k /home/$USER/.oh-my-zsh/custom/themes/powerlevel9k
sudo -u $USER sed -i 's!ZSH_THEME="robbyrussell"!ZSH_THEME="powerlevel9k/powerlevel9k"!g' /home/$USER/.zshrc
sudo -u $USER sed -i '1iexport TERM="xterm-256color"' /home/$USER/.zshrc
sudo -u $USER sed -i '1iexport LANG="en_US.UTF-8"' /home/$USER/.zshrc
sudo -u $USER sed -i '1iif [ "$TERM" = "linux" ]; then source .zshrc_nox; exit; fi' /home/$USER/.zshrc

sudo -u $USER cp /etc/skel/.zshrc ./zshrc_nox

sudo -u $USER curl -fOsS https://raw.githubusercontent.com/nipsufn/arch-install/master/.screenrc
sudo -u $USER curl -fOsS https://raw.githubusercontent.com/nipsufn/arch-install/master/.startup.sh

sudo -u $USER printf "\n~/.startup.sh\n" >> .zshrc_nox
