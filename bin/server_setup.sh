#!/bin/sh
# before starting install pip3, neovim, tmux through your package manager
# assuming apt package manager
sudo apt-get --assume-yes install neovim, python3-pip

# nvim
pip3 install --user neovim
mkdir -p ~/.config/nvim/
wget -nc https://raw.githubusercontent.com/MrCappuccino/dots/master/.config/nvim/init.vim -P ~/.config/nvim/ # nvim config

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm # tmux plugin manager
wget -nc https://raw.githubusercontent.com/MrCappuccino/dots/master/.tmux.conf -P ~/ # tmux config
tmux source-file ~/.tmux.conf # source the config
tmux # open tmux so it runs tpm
~/.tmux/plugins/tpm/bin/install_plugins # install the plugins

# some aliases
echo "alias vim='nvim'
echo alias dc='docker-compose'
echo alias dcu='docker-compose up'
echo alias dcd='docker-compose down'
echo alias dcr='docker-compose down && docker-compose up'" > ~/.bash_aliases

source ~/.bashrc # source to initialize aliases
