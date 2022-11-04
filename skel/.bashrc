#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export PATH=/home/nemo/.local/bin:$PATH
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  export GDK_BACKEND=wayland
  export XDG_SESSION_TYPE=wayland
  export XDG_SESSION_DESKTOP=sway
  export XDG_CURRENT_DESKTOP=Unity
  export XDG_CONFIG_DIR=~/.config
  export XDG_RUNTIME_DIRS=$XDG_RUNTIME_DIRS:~/.local/share/flatpak/exports/share
  export LIBSEAT_BACKEND=logind
  export QT_QPA_PLATFORM=wayland
  export QT_QPA_PLATFORMTHEME=qt5ct
  export _JAVA_AWT_WM_NONREPARENTING=1
  export MOZ_ENABLE_WAYLAND=1
  export EDITOR=vim
  dbus-run-session sway 2>&1 >> ~/.local/var/log/sway.log
fi
