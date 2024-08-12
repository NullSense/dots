export PATH=$HOME/bin/:$HOME/.cargo/bin:$HOME/.local/share/gem/ruby/3.0.0/bin:$HOME/.pyenv/bin:$HOME/.poetry/bin:$HOME/.local/bin:$PATH
export XDG_CURRENT_DESKTOP=sway
export MANPAGER='nvim +Man!'
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export XDG_SESSION_TYPE=wayland
#export GDK_BACKEND=wayland
export EDITOR=nvim
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1
export QT_FONT_DPI=96
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_FORCE_DPI=physical
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
#export SDL_VIDEODRIVER=x11
export QT_DEBUG_PLUGINS=1
export COLORTERM=truecolor
export TERM=xterm-256color
export TERM_PROGRAM="alacritty"
export TERM_PROGRAM_VERSION=$(alacritty --version | awk '{print $2}')

source ~/bin/zshaliases # aliases
source ~/bin/zshzplug # zplug plugin manager
source ~/bin/zshfzfrc # fzf functions
#source ~/bin/zshlfrc # lf file manager config

source /usr/share/nvm/init-nvm.sh

autoload -U add-zsh-hook

do-ls() {emulate -L zsh; exa -ah --icons=always --group-directories-first;}

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(bat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

bindkey -s "^\\" 'yy\n'

# add do-ls to chpwd hook
add-zsh-hook chpwd do-ls
