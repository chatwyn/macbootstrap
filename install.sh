#!/bin/sh
source basic.sh

if [[ ! -e /Applications/iTerm.app ]]; then
	brew install iterm2
	defaults delete com.googlecode.iterm2
	ln -s ~/.macbootstrap/config/com.googlecode.iterm2.plist $HOME/Library/Preferences
	# config background image location
	command="set :New\ Bookmarks:0:Background\ Image\ Location /Users/""$(whoami)""/.macbootstrap/assets/iterm-background.jpg"
	# Disable Background for performance issue
	/usr/libexec/PlistBuddy -c "$command" $HOME/Library/Preferences/com.googlecode.iterm2.plist
	defaults read -app iTerm >/dev/null
else
	echo "You have installed iTerm2"
fi

if [[ ! -e /Applications/SourceTree.app ]]; then
	brew install sourcetree
else
	echo "You have installed SourceTree"
fi

if [[ ! -e /Applications/WeChat.app ]]; then
	brew install wechat
else
	echo "You have installed WeChat"
fi

if [[ ! -e /Applications/Google\ Chrome.app ]]; then
	brew install google-chrome

	# Set Chrome as default browser
	git clone https://github.com/kerma/defaultbrowser ./tools/defaultbrowser
	(cd ./tools/defaultbrowser && make && make install)
	defaultbrowser chrome
	[[ -d ./tools/defaultbrowser ]] && rm -rf ./tools/defaultbrowser
else
	echo "You have installed chrome"
fi

if [[ ! -e /Applications/Visual\ Studio\ Code.app ]]; then
	brew install visual-studio-code
else
	echo "You have installed vscode"
fi

if brew ls --versions gnu-sed >/dev/null; then
	echo "You have installed gsed"
else
	brew install gnu-sed
fi

# install sz/rz
if brew ls --versions lrzsz >/dev/null; then
	echo "You have installed lrzsz"
else
	brew install lrzsz
fi

# install coreutils
if [[ ! -e /usr/local/opt/coreutils ]]; then
	brew install coreutils
	cp /usr/local/opt/coreutils/libexec/gnubin/gls /usr/local/opt/coreutils/libexec/gnubin/ls
else
	echo "You have installed coreutils"
fi

# install jetbrain toolbox
if [[ ! -e /Applications/JetBrains\ Toolbox.app ]]; then
	brew install jetbrains-toolbox
else
	echo "You have installed JetBrains Toolbox"
fi

curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh
brew install shiftit
brew install --cask openinterminal
brew install postman
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
brew install redis
brew_install python@3.9
brew_install cmake
brew_install gawk
brew_install autojump
brew_install wget
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
brew_install exiv2
brew_install ssh-copy-id
brew_install imagemagick
brew_install catimg
brew_install gpg
brew_install icdiff
brew_install scmpuff
brew_install fzf
brew_install fd
brew_install the_silver_searcher
brew_install nvim
brew_install exiftool
brew_install archey
brew_install ranger
brew_install git-lfs && git lfs install
brew_install cloc
$(brew --prefix)/opt/fzf/install --all

# link git config
mv ~/.gitconfig ~/.gitconfig_backup
backup_file ~/.gitattributes
ln -s ~/.macbootstrap/git-config/.gitconfig ~/.gitconfig
ln -s ~/.macbootstrap/git-config/.gitattributes ~/.gitattributes

if [[ ! -e ~/.oh-my-zsh ]]; then
	curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# zshrc setup
backup_file ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
brew_install autojump
brew_install fig
ln -s ~/.macbootstrap/zsh-config/.zshrc ~/.zshrc

# vim configuration
# backup_file ~/.vim
# backup_file ~/.config/nvim/
# git clone https://github.com/bestswifter/vim-config.git ~/.config/nvim
# ln -s ~/.config/nvim ~/.vim
# backup_file ~/.ideavimrc
# ln -s ~/.config/ideavimrc ~/.ideavimrc

# ESLint configuration
backup_file ~/.eslintrc.js
backup_file ~/.eslintrc
ln -s ~/.macbootstrap/.eslintrc.js ~/.eslintrc.js

# Ranger configuration
if [[ ! -e $HEME/.config/ranger ]]; then
	mkdir -p $HOME/.config/ranger
fi
old_commands_py=$HOME/.config/ranger/commands.py
old_rc_conf=$HOME/.config/ranger/rc.conf
backup_file "$old_commands_py"
backup_file "$old_rc_conf"
ln -s ~/.macbootstrap/config/ranger/commands.py "$old_commands_py"
ln -s ~/.macbootstrap/config/ranger/rc.conf "$old_rc_conf"

./install-steps/dependencies.before.sh

./install-steps/dependencies.after.sh
sudo ./install-steps/macos.sh

# ssh configuration
backup_file ~/.ssh/config
if [[ ! -e ~/.ssh ]]; then
	mkdir ~/.ssh
fi
ln -s ~/.macbootstrap/zsh-config/ssh_config ~/.ssh/config

# Personal
./install-steps/personal.sh
./personal.sh
