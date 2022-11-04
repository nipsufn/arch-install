#!/bin/bash

timedatectl set-ntp true
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf
sed -i 's/#\[multilib\]/[multilib]/g' /etc/pacman.conf
sed -i '/^\[multilib\]$/,+1 s.^#..' /etc/pacman.conf # uncomment next line
pacstrap /mnt \
    alacritty \
    alsa-oss \
    alsa-utils \
    base \
    base-devel \
    blueberry \
    bluez-utils \
    cmatrix \
    cpupower \
    cryptsetup \
    cups \
    dosfstools \
    e2fsprogs \
    efibootmgr \
    evince \
    exfat-utils \
    firefox \
    gammastep \
    gimp \
    git \
    gnome-keyring \
    grim \
    gvfs-afc \
    gvfs-gphoto2 \
    gvfs-mtp \
    gvfs-smb \
    intel-ucode \
    keepassxc \
    libreoffice-fresh \
    libreoffice-fresh-pl \
    light \
    linux \
    linux-firmware \
    lvm2 \
    mako \
    man-db \
    man-pages \
    network-manager-applet \
    networkmanager \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    noto-fonts-extra \
    ntfs-3g \
    openssh \
    p7zip \
    pavucontrol \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    pipewire-zeroconf \
    playerctl \
    polkit-gnome \
    qbittorrent \
    ristretto \
    sbctl \
    seahorse \
    slurp \
    solaar \
    steam \
    sudo \
    sway \
    swaybg \
    swayidle \
    swaylock \
    telegram-desktop \
    texinfo \
    thunar \
    thunar-volman \
    tmux \
    tpm2-tss \
    tree \
    ttf-dejavu \
    ttf-freefont \
    ttf-liberation \
    ttf-sourcecodepro-nerd \
    unzip \
    vim \
    vlc \
    waybar \
    wayland \
    wireplumber \
    wl-clipboard \
    wofi \
    xorg-xwayland \
    zip \
    zsh
    
#  nvidia nvidia-utils lib32-nvidia-utils
#  xf86-video-ati mesa lib32-mesa xf86-input-libinput
genfstab -U /mnt >> /mnt/etc/fstab
cd /mnt
curl -fOsS https://raw.githubusercontent.com/nipsufn/arch-install/master/arch-postinstall.sh
chmod 0755 arch-postinstall.sh
cd
arch-chroot /mnt /arch-postinstall.sh
