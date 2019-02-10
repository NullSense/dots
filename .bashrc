#
#export TERM=kitty
export PATH=$PATH:~/bin
export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH=$HOME/go
export EDITOR=nvim
export BROWSER=firefox
export MANPAGER="nvim -c 'set ft=man' -"
#Infinite history
export HISTFILESIZE=
export HISTSIZE=
export WEECHAT_HOME=~/.config/weechat

source ~/bin/spectro
source ~/bin/fuzzy
source ~/bin/extract
source ~/bin/resample_16_bit
source ~/.git-prompt.sh
source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh"
source <(kitty + complete setup bash)

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -hN --color=auto --group-directories-first'
alias shutdown='sudo shutdown now'
alias hotspot='sudo systemctl restart create_ap.service'
alias android='sudo jmtpfs -o allow_other,uid=1000 ~/.Android'
alias rsync='rsync --info=progress2'
alias vim='nvim'

#-----------------------------------------------------------------------
#
#                           PROMPT
#-----------------------------------------------------------------------

# Syntactic sugar for ANSI escape sequences
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
badgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset


PS1='\[\e[0;31m\]── \[\e[0;32m\]\W\[\e[0m\] $(__git_ps1 "\[\e[0;33m\]@\[\e[0m\] \[\e[0;34m\]%s\[\e[0m\]") '


# Fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS="--ansi --preview='bat --color always -n {+}' --preview-window=down:10"
#export FZF_DEFAULT_COMMAND="fd --color=always --type file --follow --hidden --exclude '{.local,.cache,.git,node_modules,.steam,Steam,Music}'"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.mozilla,*cache*,*Cache*,.node*,,.electron*,.local,.steam,.cache,.git,Steam,Music,Videos}" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

bind -x '"\C-p": fe;'
bind -x '"\C-k": fkill'
