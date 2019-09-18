export PATH=$PATH:$HOME/bin/:$HOME/.npm-global/bin
export EDITOR=nvim

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
zplug "plugins/rust", from:oh-my-zsh
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
alias vim="nvim"
alias gs='git status'
alias rsync='rsync --info=progress2'
alias l='ls -CFhN --color=auto --group-directories-first'
alias ll='ls -alF --color=auto --group-directories-first'
alias dropdown='nohup kitty -T dropdown_term &'

export EDITOR=nvim

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

ENABLE_CORRECTION="true"
ENABLE_WAITING_DOTS="true"

fe() {
    exec < /dev/tty
    local -r file="$(fzf)"
    [ -n "$file" ] && ${EDITOR:-vim} "$file"
}
zle -N fe
bindkey "^o" fe

LFCD="~/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
 source "$LFCD"
fi
# Open lf
source ~/.config/lf/lfcd.sh
bindkey -s "^\\" 'lfcd\n'

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.mozilla,*cache*,*Cache*,.node*,.electron*,.local,.steam,.cache,.git,Steam,Music,Videos}" 2> /dev/null'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
