export PATH=$HOME/bin/:$HOME/.cargo/bin:$HOME/.gem/ruby/2.7.0/bin:$HOME/.pyenv/bin:$HOME/.poetry/bin:$HOME/.local/bin:$HOME/.nvm/versions/node/v16.0.0/bin:$PATH
export XDG_CURRENT_DESKTOP=sway
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export XDG_SESSION_TYPE=wayland
#export GDK_BACKEND=wayland
export EDITOR=nvim
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_FORCE_DPI=physical
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
#export SDL_VIDEODRIVER=x11
export QT_DEBUG_PLUGINS=1
export COLORTERM=truecolor

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

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source $NVM_DIR/nvm.sh

# >>>> Vagrant command completion (start)
fpath=(/opt/vagrant/embedded/gems/2.2.14/gems/vagrant-2.2.14/contrib/zsh $fpath)
compinit
# <<<<  Vagrant command completion (end)
