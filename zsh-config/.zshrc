# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH:$M2_HOME/bin
export LANG=en_US.UTF-8
plugins=(extract encode64 urltools brew zsh-syntax-highlighting zsh-autosuggestions)
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="ys"
PROMPT='%B%m%~%b$(git_super_status) %# '
# PROMPT=$'%{$purple%}%n%{$reset_color%} in %{$limegreen%}%~%{$reset_color%}$(ruby_prompt_info " with%{$fg[red]%} " v g "%{$reset_color%}")$vcs_info_msg_0_%{$orange%}%{$reset_color%} at %{$hotpink%}%* %{$orange%}λ%{$reset_color%} '

source $ZSH/oh-my-zsh.sh
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle ':completion:*:*' ignored-patterns '*ORIG_HEAD'

fpath=(/usr/local/share/zsh-completions $fpath)
compinit -u

HISTCONTROL=ignorespace
HISTFILE=~/.histfile
HISTSIZE=10000000
HISTFILESIZE=10000000
SAVEHIST=10000000
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=magenta'
ZSH_AUTOSUGGEST_STRATEGY="match_prev_cmd"

BS_ZSH_BASE="$HOME/.macbootstrap"
BS_ZSH_TOOLS=${BS_ZSH_BASE}/tools

source $BS_ZSH_BASE/basic.sh
source $BS_ZSH_BASE/zsh-config/common.sh
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
if brew ls --versions scmpuff >/dev/null; then
  eval "$(scmpuff init -s --aliases=false)"
fi

fpath=(/usr/local/share/zsh-completions $fpath)

# GO
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# Homebrew
export PATH="/usr/local/sbin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# for nvm
# export NVM_DIR=~/.nvm
# export EDITOR="nvim"
#source $(brew --prefix nvm)/nvm.sh
# export NVM_SH="/usr/local/opt/nvm/nvm.sh"
# # https://github.com/creationix/nvm/issues/860

# load_nvm() {
#   [ -s "$NVM_SH" ] && . "$NVM_SH"
# }

# Bind key
# bindkey ';' autosuggest-execute

#archey -o
autoload -U bashcompinit
bashcompinit

# if brew list | grep coreutils >/dev/null; then
#   PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
alias ls='ls -F --color=auto'
eval $(gdircolors -b $HOME/.dir_colors)
# fi

if [[ -e /usr/local/opt/mysql@5.6/bin/mysql ]]; then
  export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
fi

alias pi="pod install"

export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/ruby/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export NVM_DIR="$HOME/.nvm"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# opam configuration
# test -r /Users/caowenbo/.opam/opam-init/init.zsh && . /Users/caowenbo/.opam/opam-init/init.zsh >/dev/null 2>/dev/null || true
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin
export GOROOT=/usr/local/go
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"

export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
