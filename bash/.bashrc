#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# >>>> Vagrant command completion (start)
. /opt/vagrant/embedded/gems/2.2.14/gems/vagrant-2.2.14/contrib/bash/completion.sh
# <<<<  Vagrant command completion (end)
