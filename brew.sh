#!/bin/sh

# Homebrew Script for OSX
# To execute: save and `chmod +x ./brew-install-script.sh` then `./brew-install-script.sh`

echo "Installing brew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing brew cask..."
brew tap homebrew/cask

# Programming Languages
echo "Installing programming languages..."
brew install python3
brew install go


# Dev Tools
echo "Installing development tools..."
brew install iterm2
brew install docker
brew install kubernetes-cli
brew install minikube
brew install helm
brew install kind
brew install git
brew install jenkins
brew install basex
brew install terraform
brew install tfproviderlint
brew install ansible
brew install packer
brew install vault
brew install vault-cli
brew install jenkins
brew install vsh
brew install aws-console
brew install aws-shell
brew install aws-vault
brew install awscli
brew install azure-cli
brew install geoip
brew install gh
brew install jq
brew install asciinema
brew install powershell
brew install sha3sum
brew install graphviz
brew install helm
brew install bat
brew install --cask github
brew install --cask warp
brew install --cask hyper 
brew install --cask postman
brew install --cask visual-studio-code
brew install --cask sublime-text
brew install --cask multipass
brew install --cask gitkraken
brew install --cask anaconda

# Communication Apps
echo "Installing communication apps..."
brew install --cask discord
brew install --cask keybase
brew install --cask microsoft-outlook
brew install --cask protonmail-bridge
brew install --cask slack
brew install --cask zoom
brew install --cask webex
brew install --cask webex-meetings

# Web Tools
echo "Installing web tools..."
brew install httpie
brew install wget
brew install hugo
brew install --cask downie
brew install --cask firefox
brew install --cask google-chrome
brew install --cask brave-browser
brew install --cask opera
brew install --cask postman


# File Storage
echo "Installing file storage tools..."
brew install tree
brew install --cask daisydisk
brew install --cask dropbox
brew install --cask onedrive

# Networking
echo "Installing Networking tools..."
brew install fping
brew install hping
brew install iperf3
brew install ipcalc
brew install netcalc
brew install ipinfo
brew install iproute2mac
brew install ipv6calc
brew install subnetcalc
brew install telnet
brew install mtr
brew install --cask transmit
brew install --cask wireshark
brew install --cask royal-tsx
brew install --cask drawio
brew install --cask miro


# Writing Apps
echo "Installing writing apps..."
brew install pandoc
brew install vim
brew install nvim
brew install --cask obsidian
brew install --cask notion
brew install --cask deepl
brew install --cask zotero
brew install --cask papers
brew install --cask microsoft-word
brew install --cask microsoft-powerpoint


# Video
echo "Installing video apps..."
brew install ffmpeg
brew install yt-dlp #Great Youtube Downloader
brew install --cask camtasia
brew install --cask vlc
brew install --cask iina
brew install --cask handbrake
brew install --cask inkscape
brew install --cask permute

# Productivity
echo "Installing productivity apps..."
brew install koekeishiya/formulae/skhd # https://www.josean.com/posts/yabai-setup
brew install koekeishiya/formulae/yabai #https://www.josean.com/posts/yabai-setup
brew install --cask skitch
brew install --cask skim
brew install --cask path-finder
brew install --cask fantastical
brew install --cask alfred
brew install --cask authy
brew install --cask latest
brew install --cask rectangle
brew install --cask flycut
brew install --cask raycast


# Other
echo "Installing everything else..."
brew install --cask anki
brew install --cask spotify
brew install --cask minecraft
brew install --cask paintbrush
brew install --cask istat-menus
brew install --cask imazing
brew install --cask 1password
brew install --cask coconutbattery  
brew install --cask copilot


