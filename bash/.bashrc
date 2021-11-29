# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# >>>> Vagrant command completion (start)
vagrant_completion() {
    local complettion_sh='/opt/vagrant/embedded/gems/2.2.14/gems/vagrant-2.2.14/contrib/bash/completion.sh'
    if [ -f "$complettion_sh" ]; then
        . $complettion_sh
    fi
}

vagrant_completion
# <<<<  Vagrant command completion (end)
if [[ "$OSTYPE" == "darwin"* ]]; then
    export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.sjtug.sjtu.edu.cn/homebrew-bottles/bottles
fi
