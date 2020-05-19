export PATH=$PATH:$HOME/bin/:$HOME/.npm-global/bin:$HOME/.cargo/bin:$HOME/.gem/ruby/2.7.0/bin:$HOME/.pyenv/bin
export XDG_CURRENT_DESKTOP=Unity
export EDITOR=nvim
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland-egl
export QT_WAYLAND_FORCE_DPI=physical
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export BEMENU_BACKEND=wayland
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
zplug "plugins/cargo", from:oh-my-zsh
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
alias mysql-mx-stage='mysql -u mpeciukonis -p -h dbc.stage.mx.local -D mxdb'
alias mysql-mx-live='mysql -u mpeciukonis -p -h dbc.live.mx.local -D mxdb'
alias vim="nvim"

# git aliases
alias gs='git st'
alias gcp='git cherry-pick'
alias gl="git log master..HEAD --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gll="git log master --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gri='git rebase -i'

alias rsync='rsync --info=progress2'
alias l='ls -Fh --color=auto --group-directories-first'
alias ll='ls -alF --color=auto --group-directories-first'
alias dropdown='kitty -T dropdown_term &'
alias isso='ssh -p 2237 ongo@159.69.195.170 -NL 8082:localhost:8082'
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

fe() (
  exec < /dev/tty
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
)
zle -N fe
bindkey "^p" fe

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.mozilla,*cache*,*Cache*,.node*,.electron*,.local,.steam,.cache,.git,Steam,Music,Videos}" 2> /dev/null'
# fzf colors
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg:#ebdbb2,bg:#32302f,hl:#928374
 --color=fg+:#ebdbb2,bg+:#3c3836,hl+:#fb4934
 --color=info:#8ec07c,prompt:#fb4934,pointer:#fb4934
 --color=marker:#fb4934,spinner:#fb4934,header:#928374'

export FZF_ALT_C_OPTS="--header='Jump to directory' --preview 'tree -C {} | head -200'"
export FZF_CTRL_R_OPTS="--header='Run command from history' --sort --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

gcb() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
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
