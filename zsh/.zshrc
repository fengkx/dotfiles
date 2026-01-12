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

typeset -U PATH path

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


#zi ice svn wait lucid
#zi snippet OMZP::shell-proxy

zi ice wait'2' lucid
zinit light Aloxaf/fzf-tab

zi light z-shell/z-a-bin-gem-node

#zi ice wait lucid
zi light davidparsson/zsh-pyenv-lazy

export SHELLPROXY_URL=http://127.0.0.1:7890


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


if [[ "$OSTYPE" = darwin* ]]; then
	if [[ -f /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
		export LIBRARY_PATH="/opt/homebrew/lib:$LIBRARY_PATH"
	fi
fi
export PATH="/usr/local/sbin:$PATH"

if (( $+commands[eza] )); then
	alias ls=eza
fi
if (( $+commands[bat] )); then
	alias cat=bat
fi
if (( $+commands[nvim] )); then
	alias vim=nvim
fi
if (( $+commands[deepin-terminal] )); then
	alias gnome-terminal=deepin-terminal
fi

if (( $+commands[difft] )); then
	alias dgd='GIT_EXTERNAL_DIFF=difft git diff'
fi


#volta
if (( $+commands[volta] )); then
	export VOLTA_HOME="$HOME/.volta"
fi

# fnm
if (( $+commands[fnm] )); then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi


# pnpm
if [[ "$OSTYPE" = darwin* ]]; then
	export PNPM_HOME="$HOME/Library/pnpm"
fi
path=($PNPM_HOME $path)
# pnpm end


# thefuck
## Lazyload thefuck
if (( $+commands[thefuck] )); then
  zi ice wait"0c" lucid id-as"thefuck" atload"eval \$(thefuck --alias)"
  zi light z-shell/null
fi



function find_cert_file() {
    # From https://github.com/alexcrichton/openssl-probe
    cert_dirs=(
        "/var/ssl"
        "/usr/share/ssl"
        "/usr/local/ssl"
        "/usr/local/openssl"
        "/usr/local/etc/openssl"
        "/usr/local/share"
        "/usr/lib/ssl"
        "/usr/ssl"
        "/etc/openssl"
        "/etc/pki/ca-trust/extracted/pem"
        "/etc/pki/tls"
        "/etc/ssl"
        "/etc/certs"
        "/opt/etc/ssl"
        "/data/data/com.termux/files/usr/etc/tls"
        "/boot/system/data/ssl"
    )

    cert_filenames=(
        "cert.pem"
        "certs.pem"
        "ca-bundle.pem"
        "cacert.pem"
        "ca-certificates.crt"
        "certs/ca-certificates.crt"
        "certs/ca-root-nss.crt"
        "certs/ca-bundle.crt"
        "CARootCertificates.pem"
        "tls-ca-bundle.pem"
    )

    for dir in "${cert_dirs[@]}"; do
        if [[ -d $dir ]]; then
            for file in "${cert_filenames[@]}"; do
                full_path="${dir}/${file}"
                if [[ -f $full_path ]]; then
                    echo $full_path
                    return 0
                fi
            done
        fi
        
    done
}

function setup_nodejs_openssl_env() {
        if [[ $NODE_OPTIONS != *"--use-openssl-ca"* ]]; then
            export NODE_OPTIONS="${NODE_OPTIONS} --use-openssl-ca"
        fi

        if [[ ! -n $SSL_CERT_FILE ]]; then
            cert_file=$(find_cert_file)
            export SSL_CERT_FILE="${cert_file}"
        fi
    
}

function unset_nodejs_openssl_env() {
	export NODE_OPTIONS=${NODE_OPTIONS//--use-openssl-ca/}
}


# setup_nodejs_openssl_env

path=($HOME/.cargo/bin $HOME/.local/bin $path)
export LESSCHARSET=utf-8


if [[ "$OSTYPE" = darwin* ]]; then
	if [[ ! -f "$HOME/.docker/config.json" ]] || ! grep -q '"orbstack"' "$HOME/.docker/config.json"; then
		export DOCKER_HOST=unix://$HOME/.colima/default/docker.sock
	fi
fi

alias lzd='lazydocker'
alias lzg='lazygit'
alias gitr='cd "$(git rev-parse --show-toplevel)"'


#pipx
export PIPX_BIN_DIR="$HOME/.local/pybin"
path=($PIPX_BIN_DIR $path)
export PATH="./node_modules/.bin/:$PATH"


DISABLE_LS_COLORS=true
zi ice wait lucid id-as"vivid_colors" has"vivid" \
  atload'export LS_COLORS=$(vivid generate one-dark); zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}'
zi load z-shell/null


# Added by CodeBuddy CN
path=($HOME/.codebuddy/bin $path)
