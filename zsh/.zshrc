export LANG=en_US.UTF-8
export EDITOR='vim'

ZSH_DISABLE_COMPFIX=false
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "$HOME/.zi" && command chmod go-rwX "$HOME/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "$HOME/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi
# examples here -> https://wiki.zshell.dev/ecosystem/category/-annexes
zicompinit # <- https://wiki.zshell.dev/docs/guides/commands

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# misc
setopt multios
setopt interactivecomments
export PAGER=less
export LESS='-R'


zi light z-shell/z-a-meta-plugins
zi light z-shell/z-a-eval

zi ice depth"1"
zi light romkatv/powerlevel10k

zi snippet ~/.oh-my-zsh/custom/plugins/zshfl/zshfl.plugin.zsh

zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::functions.zsh

zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

zi ice wait lucid
zinit snippet OMZP::z/z.plugin.zsh

zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent quiet yes
zi ice wait lucid
zinit snippet OMZP::ssh-agent/ssh-agent.plugin.zsh

zinit ice lucid wait='1'
zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit ice lucid wait='1'
zinit snippet OMZ::plugins/git-extras/git-extras.plugin.zsh


zi ice wait lucid
zi load z-shell/H-S-MW

zi ice wait lucid
zi light zsh-users/zsh-autosuggestions

zi ice wait lucid
zi light z-shell/F-Sy-H


zi ice svn wait lucid
zi snippet OMZP::shell-proxy

zi ice wait'2' lucid
zinit light Aloxaf/fzf-tab

zi light z-shell/z-a-bin-gem-node

zi light davidparsson/zsh-pyenv-lazy


alias ls=exa
alias cat=bat
alias vim=nvim
alias gnome-terminal=deepin-terminal
alias dgd='GIT_EXTERNAL_DIFF=difft git diff'
export SHELLPROXY_URL=http://127.0.0.1:7890

alias ls=exa

OS="$(uname -s)"
if test "$OS" = "Linux"; then
	alias open="xdg-open 2>/dev/null"
fi

# extract
extract() {
  if [ -f "$1" ] ; then
    bsdtar -xvf "$1"
  else
    echo "'$1' is not valid file"
  fi
}

zi ice id-as"doko_completion" has"doko" \
  eval"doko completion --shell bash" run-atpull
zi light z-shell/null

#history
HISTSIZE=50000
SAVEHIST=10000

source ~/.profile


# workaround for firefox bug
# https://bugzilla.mozilla.org/show_bug.cgi?id=1751363
export MOZ_DISABLE_RDD_SANDBOX=1

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# pnpm
if [[ "$OSTYPE" = darwin* ]]; then
	export PNPM_HOME="$HOME/Library/pnpm"
fi
export PATH="$PNPM_HOME:$PATH"
# pnpm end

if [[ "$OSTYPE" = darwin* ]]; then
	if [[ -f /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi

fi

# Lazyload Function

## Setup a mock function for lazyload
## Usage:
## 1. Define function "_sukka_lazyload_command_[command name]" that will init the command
## 2. sukka_lazyload_add_command [command name]
sukka_lazyload_add_command() {
    eval "$1() { \
        unfunction $1; \
        _sukka_lazyload_command_$1; \
        $1 \$@; \
    }"
}
## Setup autocompletion for lazyload
## Usage:
## 1. Define function "_sukka_lazyload_completion_[command name]" that will init the autocompletion
## 2. sukka_lazyload_add_comp [command name]
sukka_lazyload_add_completion() {
    local comp_name="_sukka_lazyload__compfunc_$1"
    eval "${comp_name}() { \
        compdef -d $1; \
        _sukka_lazyload_completion_$1; \
    }"
    compdef $comp_name $1
}


# thefuck
## Lazyload thefuck
if (( $+commands[thefuck] )) &>/dev/null; then
    _sukka_lazyload_command_fuck() {
        eval $(thefuck --alias)
    }

    sukka_lazyload_add_command fuck
fi

# pyenv lazyload
### Lazyload pyenv
#if (( $+commands[pyenv] )) &>/dev/null; then
#    _sukka_lazyload_command_pyenv() {
#        export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}" # pyenv init --path
#        eval "$(command pyenv init -)"
#    }
#    sukka_lazyload_add_command pyenv
#
#    _sukka_lazyload_completion_pyenv() {
#        source "${__SUKKA_HOMEBREW_PYENV_PREFIX}/completions/pyenv.zsh"
#    }
#    sukka_lazyload_add_completion pyenv
#
#    export PYENV_ROOT="${PYENV_ROOT:=${HOME}/.pyenv}"
#fi


export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
export LESSCHARSET=utf-8

if [[ "$OSTYPE" = darwin* ]]; then
	export DOCKER_HOST=unix://$HOME/.colima/default/docker.sock
fi

alias lzd='lazydocker'
alias lzg='lazygit'
alias gitr='cd "$(git rev-parse --show-toplevel)"'


#pipx
export PIPX_BIN_DIR="$HOME/.local/pybin"
export PATH="$PIPX_BIN_DIR:$PATH"
export PATH="./node_modules/.bin/:$PATH"


DISABLE_LS_COLORS=true
zi ice wait lucid id-as"vivid_colors" has"vivid" \
  atload'export LS_COLORS=$(vivid generate one-dark); zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}'
zi load z-shell/null
