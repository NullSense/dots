export PATH=$PATH:$HOME/bin/:$HOME/.npm-global/bin:$HOME/.cargo/bin:$HOME/.gem/ruby/2.7.0/bin:$HOME/.pyenv/bin:$HOME/.poetry/bin:$HOME/.local/bin
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export EDITOR=nvim
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_FORCE_DPI=physical
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
#export SDL_VIDEODRIVER=x11
export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
export QT_DEBUG_PLUGINS=1

source ~/bin/zshaliases # aliases
source ~/bin/zshzplug # zplug plugin manager
source ~/bin/zshfzfrc # fzf functions
source ~/bin/zshlfrc # lf file manager config

# colored man pages
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# ls after cd
function cd {
    if [ -z "$1" ]; then
        builtin cd
    else
        builtin cd "$1"
    fi
    if [ $? -eq 0 ]; then
        ls
    fi
}

# Make directory and enter into it:
mkcd () {
  case "$1" in
    */..|*/../) cd -- "$1";; # that doesn't make any sense unless the directory already exists
    /*/../*) (cd "${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd -- "$1";;
    /*) mkdir -p "$1" && cd "$1";;
    */../*) (cd "./${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd "./$1";;
    ../*) (cd .. && mkdir -p "${1#.}") && cd "$1";;
    *) mkdir -p "./$1" && cd "./$1";;
  esac
}

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
source /usr/share/nvm/init-nvm.sh
