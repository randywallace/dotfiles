setopt nohup

HISTSIZE=100000
SAVEHIST=100000

#
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="rkj-repos"
ZSH_THEME="bira"
#ZSH_THEME="docker"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"
KEYTIMEOUT=1

if [ -d "$HOME/.rvm" ]; then
  PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()
if which git > /dev/null 2>&1; then
  plugins=($plugins git git-extras github)
fi

if which rvm > /dev/null 2>&1; then
  plugins=($plugins rvm)
fi

if which ruby > /dev/null 2>&1; then
  plugins=($plugins ruby rails gem)
fi

if which bundle > /dev/null 2>&1; then
  plugins=($plugins bundler)
fi

if which command-not-found > /dev/null 2>&1; then
  plugins=($plugins command-not-found)
fi

if which aws > /dev/null 2>&1; then
  plugins=($plugins aws)
fi

if which tmux > /dev/null 2>&1; then
  plugins=($plugins tmux)
fi

if which docker > /dev/null 2>&1; then
  plugins=($plugins docker)
fi

if which apt-get > /dev/null 2>&1; then
  plugins=($plugins debian)
fi

if which npm > /dev/null 2>&1; then
  plugins=($plugins npm)
fi

if which yum > /dev/null 2>&1; then
  plugins=($plugins yum)
fi

if which ssh-agent > /dev/null 2>&1; then
  plugins=($plugins ssh-agent)
fi
# Customize to your needs...

bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey -sM vicmd '^[' '^G'
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^U" kill-line
bindkey "^H" backward-delete-char

alias vi=vim

id_files=$(cd $HOME/.ssh && ls | grep 'id_' | grep -v -E '\.pub$')
id_files=(${=id_files})
if [ "$id_files[(I)$id_files[-1]]" -gt 0 ]; then
  zstyle :omz:plugins:ssh-agent identities $id_files
fi

source $ZSH/oh-my-zsh.sh

if [ -e /etc/profile.d/rvm.sh ]; then
  source /etc/profile.d/rvm.sh
fi

if [ -e $HOME/dotfiles ]; then
  pushd $HOME/dotfiles > /dev/null 2>&1
  git submodule update --init --recursive
  vim +BundleClean! +BundleInstall +qall now
  popd >/dev/null 2>&1
fi
