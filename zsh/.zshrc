ZSH_DISABLE_COMPFIX=false
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# I use exa
DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	git-extras
	shell-proxy
	sudo
	z
	fast-syntax-highlighting
	zsh-autosuggestions
	fzf-tab
	ssh-agent
	pyenv-lazy
	zshfl
)


# ssh-agent settings
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent quiet yes


source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='vim'
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ls=exa
alias cat=bat
alias vim=nvim
alias gnome-terminal=deepin-terminal
alias dgd='GIT_EXTERNAL_DIFF=difft git diff'
export SHELLPROXY_URL=http://127.0.0.1:7890

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

OS="$(uname -s)"
if test "$OS" = "Linux"; then
	alias open="xdg-open 2>/dev/null"
fi

# >>>> Vagrant command completion (start)
fpath=(/opt/vagrant/embedded/gems/2.2.14/gems/vagrant-2.2.14/contrib/zsh $fpath)
compinit
# <<<<  Vagrant command completion (end)
#

# extract
extract() {
  if [ -f "$1" ] ; then
    bsdtar -xvf "$1"
  else
    echo "'$1' is not valid file"
  fi
}

(( $+commands[doko] )) && eval "$(doko completion --shell bash)"

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
