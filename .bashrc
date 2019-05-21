bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
set -o vi

export PATH=$PATH:~/bin:~/.config/i3/scripts
export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH=$HOME/go
export EDITOR=nvim
#export BROWSER=firefox
export MANPAGER="nvim -c 'set ft=man' -"
#Infinite history
export HISTFILESIZE=
export HISTSIZE=
export WEECHAT_HOME=~/.config/weechat
export TERMINAL=kitty

source ~/bin/spectro
source ~/bin/fuzzy
source ~/bin/resample_16_bit
source ~/bin/.git-prompt.sh
source <(kitty + complete setup bash)

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -hN --color=auto --group-directories-first'
alias hotspot='sudo systemctl restart create_ap.service'
alias android='sudo jmtpfs -o allow_other,uid=1000 ~/.Android'
alias rsync='rsync --info=progress2'
alias vim='nvim'
alias r='. ranger'
alias nb='newsboat'

PS1='\[\e[0;31m\]── \[\e[0;32m\]\W\[\e[0m\] $(__git_ps1 "\[\e[0;33m\]@\[\e[0m\] \[\e[0;34m\]%s\[\e[0m\]") '

# Fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--ansi'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.mozilla,*cache*,*Cache*,.node*,.electron*,.local,.steam,.cache,.git,Steam,Music,Videos}" 2> /dev/null'

bind -x '"\C-p": fe;'
bind -x $'"\C-l": clear;'
