#!/bin/bash
set -euo pipefail

# Pass the user name, host name and machine-specific boot settings in the
# environment when running this script. Validate them before making any system
# changes.
: "${NEW_USER:?Set NEW_USER to the name of the user account to create}"
: "${NEW_HOSTNAME:?Set NEW_HOSTNAME to the host name for this machine}"
: "${EFI_DISK:?Set EFI_DISK to the disk containing the EFI System Partition}"
: "${EFI_PART:?Set EFI_PART to the EFI System Partition number}"
: "${LUKS_UUID:?Set LUKS_UUID to the encrypted root partition UUID}"
: "${CRYPT_NAME:?Set CRYPT_NAME to the name used by rd.luks.name}"
: "${ROOT_DEVICE:?Set ROOT_DEVICE to the root device path}"
: "${RESUME_DEVICE:?Set RESUME_DEVICE to the swap device path}"

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
echo "$NEW_HOSTNAME" > /etc/hostname
cp /etc/locale.gen /etc/locale.gen.bak
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#pl_PL.UTF-8 UTF-8/pl_PL.UTF-8 UTF-8/g' /etc/locale.gen
cat <<EOT > /etc/locale.conf
LANG=en_US.UTF-8
LC_MONETARY=pl_PL.UTF-8
LC_MEASUREMENT=pl_PL.UTF-8
LC_NUMERIC=pl_PL.UTF-8
LC_PAPER=pl_PL.UTF-8
LC_TELEPHONE=pl_PL.UTF-8
LC_TIME=pl_PL.UTF-8
EOT
locale-gen
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable avahi-daemon
# Keeps the last three versions of each package in the pacman cache.
systemctl enable paccache.timer

cp /etc/pacman.conf /etc/pacman.conf.bak
sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#\[multilib\]/[multilib]/g' /etc/pacman.conf
sed -i '/^\[multilib\]$/,+1 s.^#..' /etc/pacman.conf # uncomment next line

# battery level reporting for some bluetooth devices
cp /etc/bluetooth/main.conf /etc/bluetooth/main.conf.bak
sed -i 's/#Experimental = true/Experimental = true/g' /etc/bluetooth/main.conf
sed -i 's/#KernelExperimental = true/KernelExperimental = true/g' /etc/bluetooth/main.conf


# wheel is for sudo and polkit admin prompts. Device access comes from logind
# for whoever is logged in at the machine, plus the rules in system/.
useradd -m -G wheel "$NEW_USER"

efibootmgr \
    --create \
    --disk "$EFI_DISK" \
    --part "$EFI_PART" \
    --label "Arch Linux" \
    --loader /vmlinuz-linux-zen \
    --unicode "rd.luks.name=${LUKS_UUID}=${CRYPT_NAME} rd.luks.options=discard root=${ROOT_DEVICE} resume=${RESUME_DEVICE} rw initrd=\\initramfs-linux-zen.img"

cd "/home/$NEW_USER"

# Clone before unpacking skel: its ~/.gitconfig rewrites GitHub https URLs to
# SSH, which needs a key that is not set up yet.
sudo -u "$NEW_USER" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "/home/$NEW_USER/powerlevel10k"

sudo -u "$NEW_USER" curl -fOsS https://codeload.github.com/nipsufn/arch-install/zip/master
sudo -u "$NEW_USER" bash -c 'shopt -s dotglob && unzip master arch-install-master/skel/* && mv arch-install-master/skel/* ./ && rmdir -p arch-install-master/skel && shopt -u dotglob'

# udev, polkit, sudo and mkinitcpio only read root-owned files, so these are
# copied into /etc. visudo -c reports sudoers files that are not mode 0440 as
# errors.
tmp=$(mktemp -d)
unzip -q master 'arch-install-master/system/*' -d "$tmp"
cp -r "$tmp/arch-install-master/system/." /
rm -rf "$tmp"
chmod 0440 /etc/sudoers.d/wheel
visudo -c -q || echo "Warning: sudoers configuration is invalid; check /etc/sudoers.d/wheel" >&2
mkinitcpio -P

sudo -u "$NEW_USER" rm master

# root keeps a password for the emergency shell, which asks for it when boot fails.
echo "Set the root password:"
until passwd root; do :; done
echo "Set the password for $NEW_USER:"
until passwd "$NEW_USER"; do :; done

echo
echo "After the first login, set user.email and user.signingkey in ~/.gitconfig."
