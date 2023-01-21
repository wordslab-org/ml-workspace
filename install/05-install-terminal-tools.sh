# https://github.com/ml-tooling/ml-workspace
# https://github.com/LukasMasuch
apt-get update

# tmux : terminal multiplexer
apt-get install -y --no-install-recommends tmux

# csh : Shell with C-like syntax
apt-get install -y --no-install-recommends csh

# xclip : command line interface to X selections
apt-get install -y --no-install-recommends xclip

# libncurses5-dev : transitional package for libncurses-dev
apt-get install -y --no-install-recommends libncurses5-dev

# libncursesw5-dev : transitional package for libncurses-dev
apt-get install -y --no-install-recommends libncursesw5-dev

# libreadline-dev : GNU readline and history libraries, development files
apt-get install -y --no-install-recommends libreadline-dev

# libedit-dev : BSD editline and history libraries (development files)
apt-get install -y --no-install-recommends libedit-dev

# gawk : GNU awk, a pattern scanning and processing language
apt-get install -y --no-install-recommends gawk

# screen : terminal multiplexer with VT100/ANSI terminal emulation
apt-get install -y --no-install-recommends screen

# nano : small, friendly text editor inspired by Pico
apt-get install -y --no-install-recommends nano

# vim : Vi IMproved - enhanced vi editor
apt-get install -y --no-install-recommends vim

# less : pager program similar to more
apt-get install -y --no-install-recommends less

# bash-completion : programmable completion for the bash shell
apt-get install -y --no-install-recommends bash-completion

# Cleanup
clean-layer.sh

# Layer size: 61 MB 
# - vim = 43 MB
# Total size: 556 MB
