export PATH=$PATH:$HOME/bin/
export EDITOR=nvim
export MANPAGER="nvim -c 'set ft=man' -"
#Infinite history
export HISTFILESIZE=
export HISTSIZE=
export WEECHAT_HOME=~/.config/weechat
export TERMINAL=kitty
export OPENER=rifle

source /usr/share/git/completion/git-prompt.sh
source /usr/share/git/completion/git-completion.bash
source /usr/share/bash-completion/bash_completion
source ~/bin/extract.sh
source ~/.config/lf/lfcd.sh
source <(kitty + complete setup bash)

alias ls='ls -hN --color=auto --group-directories-first'
alias hotspot='sudo systemctl restart create_ap.service'
alias android='sudo jmtpfs -o allow_other,uid=1000 ~/.Android'
alias rsync='rsync --info=progress2'
alias vim='nvim'
alias nb='newsboat'
alias clip='xclip -selection clipboard'

PS1='\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W$(__git_ps1 "\[\e[0;33m\]@\[\e[0m\] \[\e[0;34m\]%s\[\e[0m\]")\[$(tput bold)\]\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]'

# Fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.mozilla,*cache*,*Cache*,.node*,.electron*,.local,.steam,.cache,.git,Steam,Music,Videos}" 2> /dev/null'

# open fzf file in vim
fe() {
    local -r file="$(fzf)"
    [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

#setxkbmap -option 'caps:ctrl_modifier' && xcape -e 'Caps_Lock=Escape' &

bind -x '"\C-p": fe;'
bind -x $'"\C-l": clear;'
bind '"\C-o":"lfcd\C-m"'
