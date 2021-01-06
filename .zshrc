export PATH=$PATH:$HOME/bin/:$HOME/.npm-global/bin:$HOME/.cargo/bin:$HOME/.gem/ruby/2.7.0/bin:$HOME/.pyenv/bin:$HOME/.poetry/bin
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export EDITOR=nvim
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland-egl
export QT_WAYLAND_FORCE_DPI=physical
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
#export SDL_VIDEODRIVER=x11
export PYENV_ROOT=$HOME/.pyenv
export QT_DEBUG_PLUGINS=1

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# 10ms timeout instead of 40ms
KEYTIMEOUT=1

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

autoload -U compinit && compinit

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug 'zdharma/fast-syntax-highlighting', \
      hook-load:'FAST_HIGHLIGHT=()', defer:2
zplug "b4b4r07/zsh-vimode-visual", defer:3
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "plugins/fzf", from:oh-my-zsh
zplug "MichaelAquilina/zsh-you-should-use"
zplug "wfxr/forgit"

# theme
eval "$(starship init zsh)"

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

# Aliases
# Pacman
# search through all available packages, install selected
alias pss="pacman -Slq | fzf --multi --preview 'pacman --color=always -Si {1}' | xargs -ro sudo pacman -S"
# List all your installed packages, and then remove selected packages:
alias pqs="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
# Trizen
# search through all available packages, install selected
alias tss="trizen -SQqs | fzf --bind 'change:reload:(trizen -SQaqs {q})' --multi --preview 'trizen -Sai --forcecolors {1}' | xargs -ro sudo trizen -S"

alias vim="nvim"
# Docker
alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dcr="docker-compose restart"

# git aliases
alias gs='git st'
alias gcp='git cherry-pick'
alias gl="git log master..HEAD --graph --pretty=format:'%Cred%h%Creset %Cgreen(%<(10,trunc)%cr) %C(bold blue)%<(16,trunc)<%an>%Creset %s %C(yellow)%d%Creset' --abbrev-commit --date=relative"
alias gll="git log master --graph --pretty=format:'%Cred%h%Creset %Cgreen(%<(10,trunc)%cr) %C(bold blue)%<(16,trunc)<%an>%Creset %s %C(yellow)%d%Creset' --abbrev-commit --date=relative"
alias gri='git rebase -i'
alias grc='git rebase --continue'
alias grm="git rebase master"
alias gc="git checkout"

alias rsync='rsync --info=progress2'
alias l='ls -Fh --color=auto --group-directories-first'
alias ll='ls -alF --color=auto --group-directories-first'
alias dropdown='nohup alacritty -t dropdown_term > /dev/null 2>&1 &|'
alias isso='ssh irc -NLvv 8080:localhost:8080'
alias ls="exa"
alias cat="bat"
alias find="fd"
alias pytest="pytest --reuse-db --reruns 0 -n auto"
alias pyl="pytest --reuse-db --lf -n0 -fsvv"
alias back="cd ~/work/mx-backend/src && pyenv activate mx-backend-3.6.8"
alias front="cd ~/work/mx-webapp && nvm use"

setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt extended_history
setopt hist_expand
setopt share_history
setopt prompt_subst

zstyle ':completion:*' menu select
bindkey '^ ' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="bold,underline"

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

# fedit - edit systemd unit
fedit() {
  unit=$(systemctl list-unit-files --type=service |
    awk '{print $1}' | grep service | fzf --ansi --preview="SYSTEMD_COLORS=1 systemctl cat {}")
  [ -n "$unit" ] && sudo systemctl edit --full $unit &&
    journalctl -feu $unit --since "10 sec ago" --no-pager
}

# fenable - enable and start systemd unit
fenable() {
  unit=$(systemctl list-unit-files --type=service --state=disabled |
    awk '{print $1}' | grep service | fzf --ansi --preview="SYSTEMD_COLORS=1 systemctl status --no-pager {}")
  [ -n "$unit" ] && sudo systemctl enable --now $unit &&
    journalctl -feu $unit --since "10 sec ago" --no-pager
}

# fdisable - disable and stop systemd unit
fdisable() {
  unit=$(systemctl list-unit-files --type=service --state=enabled |
    awk '{print $1}' | grep service | fzf --ansi --preview="SYSTEMD_COLORS=1 systemctl status --no-pager {}")
  [ -n "$unit" ] && sudo systemctl disable --now $unit &&
    journalctl -feu $unit --since "10 sec ago" --no-pager
}

# fstart - start systemd unit
fstart() {
  unit=$(systemctl list-unit-files --type=service --state=inactive,failed,exited,stopped,disabled |
    awk '{print $1}' | grep service | fzf --ansi --preview="SYSTEMD_COLORS=1 systemctl status --no-pager {}")
  [ -n "$unit" ] && sudo systemctl start $unit &&
    journalctl -eu $unit --since "10 sec ago" --no-pager
}

# fstop - stop systemd unit
fstop() {
  unit=$(systemctl list-units --type=service --state=running |
    awk '{print $1}' | grep service | fzf --ansi --preview="SYSTEMD_COLORS=1 systemctl status --no-pager {}")
  [ -n "$unit" ] && sudo systemctl stop $unit &&
    journalctl -eu $unit --since "10 sec ago" --no-pager
}

# fstat - show systemd unit status
fstat() {
  unit=$(systemctl list-unit-files --type=service |
    awk '{print $1}' | grep service | fzf --ansi --preview="SYSTEMD_COLORS=1 systemctl status --no-pager {}")
  [ -n "$unit" ] && journalctl -eu $unit --since "10 sec ago" --no-pager
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

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# open file in vim with preview
fe() (
  exec < /dev/tty
  IFS=$'\n' files=($(fzf --preview 'bat --style=numbers --color=always --line-range :30 {}' --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
)
zle -N fe
bindkey "^p" fe

export FZF_DEFAULT_COMMAND='rg --column --line-number --no-heading --smart-case --files --hidden --follow -g "!{.mozilla,.wine,*cache*,*Cache*,.node*,.electron*,.local,.steam,.cache,.git,Steam,Music,Videos,.vscode*,.gradle,.nvm,.zplug,.forgit,.cargo,.m2,.pyenv}" 2> /dev/null'
# fzf colors
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--border
--color='fg:#ebdbb2,bg:#32302f,hl:#928374'
--color='fg+:#ebdbb2,bg+:#3c3836,hl+:#fb4934'
--color='info:#8ec07c,prompt:#fb4934,pointer:#fb4934'
--color='marker:#fb4934,spinner:#fb4934,header:#928374''

export FZF_ALT_C_OPTS="--header='Jump to directory' --preview 'tree -C {} | head -200'"
export FZF_CTRL_R_OPTS="--header='Run command from history' --sort --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

gcb() {
  local tags branches target
  branches=$(
    git --no-pager branch --sort=-committerdate --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git log master..HEAD --graph --pretty=format:'%Cgreen(%<(7,trunc)%cr) %C(bold blue)%<(7,trunc)<%an>%Creset %s %C(yellow)%d%Creset' --color=always --abbrev-commit --date=relative '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

w() {
    notify-send "$(curl wttr.in/Berlin 2>/dev/null 3>/dev/null | head -n 7| sed -r "s:\x1B\[[0-9;]*[mK]::g")"
}

LFCD="~/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
 source "$LFCD"
fi
# Open lf
source ~/.config/lf/lfcd.sh
bindkey -s "^\\" 'lfcd\n'

export LF_ICONS="\
di=:\
fi=:\
ln=:\
or=:\
ex=:\
*.c=:\
*.cc=:\
*.clj=:\
*.coffee=:\
*.cpp=:\
*.css=:\
*.d=:\
*.dart=:\
*.erl=:\
*.exs=:\
*.fs=:\
*.go=:\
*.h=:\
*.hh=:\
*.hpp=:\
*.hs=:\
*.html=:\
*.java=:\
*.jl=:\
*.js=:\
*.json=:\
*.lua=:\
*.md=:\
*.php=:\
*.pl=:\
*.pro=:\
*.py=:\
*.rb=:\
*.rs=:\
*.scala=:\
*.ts=:\
*.vim=:\
*.cmd=:\
*.ps1=:\
*.sh=:\
*.bash=:\
*.zsh=:\
*.fish=:\
*.tar=:\
*.tgz=:\
*.arc=:\
*.arj=:\
*.taz=:\
*.lha=:\
*.lz4=:\
*.lzh=:\
*.lzma=:\
*.tlz=:\
*.txz=:\
*.tzo=:\
*.t7z=:\
*.zip=:\
*.z=:\
*.dz=:\
*.gz=:\
*.lrz=:\
*.lz=:\
*.lzo=:\
*.xz=:\
*.zst=:\
*.tzst=:\
*.bz2=:\
*.bz=:\
*.tbz=:\
*.tbz2=:\
*.tz=:\
*.deb=:\
*.rpm=:\
*.jar=:\
*.war=:\
*.ear=:\
*.sar=:\
*.rar=:\
*.alz=:\
*.ace=:\
*.zoo=:\
*.cpio=:\
*.7z=:\
*.rz=:\
*.cab=:\
*.wim=:\
*.swm=:\
*.dwm=:\
*.esd=:\
*.jpg=:\
*.jpeg=:\
*.mjpg=:\
*.mjpeg=:\
*.gif=:\
*.bmp=:\
*.pbm=:\
*.pgm=:\
*.ppm=:\
*.tga=:\
*.xbm=:\
*.xpm=:\
*.tif=:\
*.tiff=:\
*.png=:\
*.svg=:\
*.svgz=:\
*.mng=:\
*.pcx=:\
*.mov=:\
*.mpg=:\
*.mpeg=:\
*.m2v=:\
*.mkv=:\
*.webm=:\
*.ogm=:\
*.mp4=:\
*.m4v=:\
*.mp4v=:\
*.vob=:\
*.qt=:\
*.nuv=:\
*.wmv=:\
*.asf=:\
*.rm=:\
*.rmvb=:\
*.flc=:\
*.avi=:\
*.fli=:\
*.flv=:\
*.gl=:\
*.dl=:\
*.xcf=:\
*.xwd=:\
*.yuv=:\
*.cgm=:\
*.emf=:\
*.ogv=:\
*.ogx=:\
*.aac=:\
*.au=:\
*.flac=:\
*.m4a=:\
*.mid=:\
*.midi=:\
*.mka=:\
*.mp3=:\
*.mpc=:\
*.ogg=:\
*.ra=:\
*.wav=:\
*.oga=:\
*.opus=:\
*.spx=:\
*.xspf=:\
*.pdf=:\
"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
source /usr/share/nvm/init-nvm.sh
