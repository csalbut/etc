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
# point ansible to the correct python version.
# node-side solution:
# sudo ln -s /usr/bin/python2.7 /usr/bin/python
# or control-side solution: ansible inventory entry:
# 192.168.1.15 ansible_python_interpreter=/usr/bin/python2
