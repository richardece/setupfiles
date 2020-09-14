#originally from
#https://gist.github.com/9b1cca1e387b1a494b0533b33c9bcc67.git

xcode-select --install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew cask install iterm2
# update profile->keys->preset->natural text editing
# general->working directory->reuse previous working directory
# update iterm2 settings -> colors, keep directory open new shell, keyboard shortcuts
brew install bash # latest version of bash
# which bash to find out where is the bash installed
# add /usr/local/bin/bash to /etc/shells
# chsh -s /usr/local/bin/bash
# set brew bash as default shell
brew install fortune
brew install cowsay 
brew install git
brew install vcprompt
# update bash_profile
brew cask install spectacle
brew cask install alfred
brew cask install keepingyouawake
# set CMD+space to launch alfred
brew cask install firefox
# install nvm/node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
nvm install stable
mkdir ~/workspace
npm install -g lite-server eslint
brew cask install visual-studio-code
# update vscode settings
# install vscode extensions

brew install cmake
#create ~/.bashrc
# add
# PATH="/Applications/CMake.app/Contents/bin":"$PATH"


#download xcode from website, extract and drag to /Applications
