#!/bin/bash
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

ps x | grep xinit | grep -v grep > /dev/null
if [ $? -eq 1 ] && [ $XDG_VTNR -eq 1 ]; then
	cinnamon-session
fi

