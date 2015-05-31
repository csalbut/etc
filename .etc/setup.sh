#!/bin/sh

ln -s ~/.etc/tmux.conf ~/.tmux.conf

# TODO on a fresh machine:
# create user cs
# install sudo
# add user cs to sudoers: visudo
#
# as cs:
# install git, zsh, vim
# chsh -s /bin/zsh cs
# start zsh, do not create .zshrc
# clone vcsh, link to /usr/bin
# pull all vcsh repos
# pull vcsh-modules
# vcsh <repo> submodule update --init
#
