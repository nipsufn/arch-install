#!/bin/bash
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

ps x | grep xinit | grep -v grep > /dev/null
if [ $? -eq 1 ] && [ $XDG_VTNR -eq 1 ]; then
	startx
else
	PS="%B%F{red}%(?..%? )%f%b%B%F{red}%n%f%b@%m %B%40<..<%~%<< %b%F{magenta}(%fgit%F{magenta})%F{yellow}-%F{magenta}[%F{green}master%F{magenta}]%f %# "
fi

