#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	export GDK_BACKEND=wayland
	export XDG_SESSION_TYPE=wayland
	export XDG_SESSION_DESKTOP=sway
	export XDG_CURRENT_DESKTOP=sway
	export LIBSEAT_BACKEND=logind
	export QT_QPA_PLATFORM=wayland
	dbus-run-session sway 2>&1 >> ~/.local/var/log/sway.log
fi
