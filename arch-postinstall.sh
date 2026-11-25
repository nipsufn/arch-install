#!/bin/bash
USER="nemo"

# Pass the machine-specific boot settings in the environment when running this
# script. Validate them before making any system changes.
: "${EFI_DISK:?Set EFI_DISK to the disk containing the EFI System Partition}"
: "${EFI_PART:?Set EFI_PART to the EFI System Partition number}"
: "${LUKS_UUID:?Set LUKS_UUID to the encrypted root partition UUID}"
: "${CRYPT_NAME:?Set CRYPT_NAME to the name used by rd.luks.name}"
: "${ROOT_DEVICE:?Set ROOT_DEVICE to the root device path}"
: "${RESUME_DEVICE:?Set RESUME_DEVICE to the swap device path}"

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
cp /etc/locale.gen /etc/locale.gen.bak
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#pl_PL.UTF-8 UTF-8/pl_PL.UTF-8 UTF-8/g' /etc/locale.gen
cp /etc/locale.conf /etc/locale.conf.bak
cat <<EOT >> /etc/locale.conf
LANG=en_US.UTF-8
LC_MONETARY=pl_PL.UTF-8
LC_MEASUREMENT=pl_PL.UTF-8
LC_NUMERIC=pl_PL.UTF-8
LC_PAPER=pl_PL.UTF-8
LC_TELEPHONE=pl_PL.UTF-8
LC_TIME=pl_PL.UTF-8
EOT
locale-gen
#mkinitcpio -p linux
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable avahi-daemon

cp /etc/pacman.conf /etc/pacman.conf.bak
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf
sed -i 's/#\[multilib\]/[multilib]/g' /etc/pacman.conf
sed -i '/^\[multilib\]$/,+1 s.^#..' /etc/pacman.conf # uncomment next line

# battery level reporting for some bluetooth devices
cp /etc/bluetooth/main.conf /etc/bluetooth/main.conf.bak
sed -i 's/#Experimental = true/Experimental = true/g' /etc/bluetooth/main.conf
sed -i 's/#KernelExperimental = true/KernelExperimental = true/g' /etc/bluetooth/main.conf


useradd -m $USER
usermod -aG wheel,users,games,uucp,audio,disk,floppy,input,kvm,optical,scanner,storage,video,network,power $USER
#sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers

efibootmgr \
    --create \
    --disk "$EFI_DISK" \
    --part "$EFI_PART" \
    --label "Arch Linux" \
    --loader /vmlinuz-linux \
    --u "rd.luks.name=${LUKS_UUID}=${CRYPT_NAME} root=${ROOT_DEVICE} resume=${RESUME_DEVICE} rw initrd=\\intel-ucode.img initrd=\\initramfs-linux.img"

cd /home/$USER

sudo -u $USER systemctl --user enable syncthing
sudo -u $USER curl -fOsS https://codeload.github.com/nipsufn/arch-install/zip/master
sudo -u $USER bash -c 'shopt -s dotglob && unzip master arch-install-master/skel/* && mv arch-install-master/skel/* ./ && rmdir -p arch-install-master/skel && shopt -u dotglob'
sudo -u $USER rm master
