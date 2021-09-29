#!/bin/bash

timedatectl set-ntp true
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
sed -i 's/#\[multilib\]/[multilib]/g' /etc/pacman.conf
sed -i '/^\[multilib\]$/,+1 s.^#..' /etc/pacman.conf
pacstrap /mnt \
    alacritty \
    alsa-oss \
    alsa-utils \
    awesome-terminal-fonts \
    base \
    base-devel \
    blender \
    blueman \
    bluez \
    bluez-utils \
    brlaser \
    celluloid \
    cmatrix \
    cpupower \
    cryptsetup \
    cups \
    dosfstools \
    e2fsprogs \
    efibootmgr \
    exfat-utils \
    firefox \
    gimp \
    git \
    gvfs-afc \
    gvfs-gphoto2 \
    gvfs-mtp \
    gvfs-smb \
    intel-ucode \
    jq \
    keepassxc \
    linux \
    linux-firmware \
    lvm2 \
    man-db \
    man-pages \
    networkmanager \
    noto-fonts \
    noto-fonts-emoji \
    ntfs-3g \
    openssh \
    polkit \
    pulseaudio \
    qbittorrent \
    ristretto \
    steam \
    sudo \
    sway \
    telegram-desktop \
    thunar \
    thunar-volman \
    textinfo \
    tmux \
    tree \
    ttf-dejavu \
    ttf-freefont \
    ttf-liberation \
    vim \
    vlc \
    waybar \
    wayland \
    wofi \
    xwayland \
    zsh \
    
#  nvidia nvidia-utils lib32-nvidia-utils
#  xf86-video-ati mesa lib32-mesa xf86-input-libinput
genfstab -U /mnt >> /mnt/etc/fstab
cd /mnt
curl -fOsS https://raw.githubusercontent.com/nipsufn/arch-install/master/arch-postinstall.sh
chmod 0755 arch-postinstall.sh
cd
arch-chroot /mnt /arch-postinstall.sh
