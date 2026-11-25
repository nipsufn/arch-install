#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

fg_green="\[$(tput setaf 2)\]"
fg_blue="\[$(tput setaf 4)\]"
bold="\[$(tput bold)\]"
reset="\[$(tput sgr0)\]"
PS1="${bold}${fg_green}\u@\h:${fg_blue}\w \$${reset} "

if [ -z "$XDG_RUNTIME_DIR" ]; then
  export XDG_RUNTIME_DIR="/run/user/$(id -u)"
fi

export PATH="$HOME/.local/bin:$PATH"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
fi

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  export GDK_BACKEND=wayland
  export GTK_THEME=Adwaita:dark
  export XDG_SESSION_TYPE=wayland
  export XDG_SESSION_DESKTOP=sway
  export XDG_CURRENT_DESKTOP=sway
  export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}:${HOME}/.local/share/flatpak/exports/share"
  export LIBSEAT_BACKEND=logind
  export QT_QPA_PLATFORM=wayland
  export QT_QPA_PLATFORMTHEME=qt6ct
  export _JAVA_AWT_WM_NONREPARENTING=1
  export MOZ_ENABLE_WAYLAND=1
  export EDITOR=vim
  exec dbus-run-session sway >> ~/.local/var/log/sway.log 2>&1
fi

set enable-bracketed-paste on
