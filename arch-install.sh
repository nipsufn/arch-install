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
    evince \ # document / pdf viewer
    exfat-utils \
    firefox \
    gimp \
    git \
    gnome-keyring \
    grim \ # print-screen: dump region to stdout
    gvfs-afc \
    gvfs-gphoto2 \
    gvfs-mtp \
    gvfs-smb \
    intel-ucode \
    keepassxc \
    libreoffice-fresh \
    libreoffice-fresh-pl \
    light \ # control backlight from terminals /bindkeys
    linux \
    linux-firmware \
    lvm2 \
    mako \ # notifications
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
    pavucontrol \ # ui sliders for audio settings
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    pipewire-zeroconf \ # audio over network
    playerctl \ # control media players from terminal / bindkeys
    polkit-gnome \
    qbittorrent \
    ristretto \ # image viewer
    sbctl \
    seahorse \ # frontend for gnome-keyring
    slurp \ # print-screen: select destop region
    solaar \ # logitech wireless
    steam \
    sudo \
    sway \
    swaybg \
    swayidle \
    swaylock \
    telegram-desktop \
    textinfo \
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
    wl-clipboard \ # print-screen: copy to clipboard
    wofi \
    xwayland \
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
