#!/bin/bash
set -euo pipefail

timedatectl set-ntp true
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#\[multilib\]/[multilib]/g' /etc/pacman.conf
sed -i '/^\[multilib\]$/,+1 s.^#..' /etc/pacman.conf # uncomment next line
pacstrap /mnt \
    7zip \
    alacritty \
    base \
    base-devel \
    bash-completion \
    blueman \
    breeze \
    brightnessctl \
    bluez-utils \
    cmatrix \
    cryptsetup \
    cups \
    dosfstools \
    e2fsprogs \
    efibootmgr \
    evince \
    exfatprogs \
    firefox \
    gammastep \
    gimp \
    git \
    grim \
    gvfs-afc \
    gvfs-gphoto2 \
    gvfs-mtp \
    gvfs-smb \
    intel-media-driver \
    intel-ucode \
    kate \
    keepassxc \
    konsole \
    lib32-vulkan-intel \
    libreoffice-fresh \
    libreoffice-fresh-pl \
    linux-firmware \
    linux-zen \
    lvm2 \
    mako \
    man-db \
    man-pages \
    network-manager-applet \
    networkmanager \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    ntfs-3g \
    openssh \
    pacman-contrib \
    pavucontrol \
    pipewire \
    pipewire-alsa \
    pipewire-jack \
    pipewire-pulse \
    pipewire-zeroconf \
    playerctl \
    polkit-gnome \
    python-dbus \
    qbittorrent \
    qt6ct \
    ristretto \
    slurp \
    solaar \
    steam \
    stow \
    sudo \
    sway \
    swaybg \
    swayidle \
    swaylock \
    syncthing \
    telegram-desktop \
    texinfo \
    thunar \
    thunar-volman \
    tmux \
    tree \
    ttf-dejavu \
    ttf-firacode-nerd \
    ttf-liberation \
    unzip \
    vim \
    vlc \
    vulkan-intel \
    waybar \
    wayland \
    wireplumber \
    wl-clipboard \
    wofi \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-wlr \
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
