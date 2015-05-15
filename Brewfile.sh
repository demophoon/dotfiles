# ============================================================================
# Brewfile - One to install them all
# Britt Gresham
# ============================================================================

# Backwards compatibility functions for Brewfiles

update() {
    echo "Updating brew..."
    brew update
}

tap() {
    echo "Tapping $*..."
    brew tap $*
}

install() {
    echo "Installing $*..."
    brew install $*
}

cask() {
    shift
    echo "Installing $*..."
    brew cask install $*
}

if [ -x "$(which brew)" ]; then
    echo "Brew is installed."
else
    echo "Installing brew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Brew
update

# Add additional taps
tap homebrew/dupes
tap phinze/cask
tap samueljohn/python
tap neovim/homebrew-neovim

install git
install mercurial

install vim
install tmux
install --HEAD neovim

install python
install ruby
install rbenv

install gti

# ============================================================================
# Cask Installs
# ============================================================================

# Approved
install brew-cask
cask install google-chrome
cask install google-hangouts
cask install iterm2
cask install virtualbox
cask install vagrant
cask install slate
cask install flux
cask install caffeine
cask install tunnelblick

# Testing
cask install alfred
cask install google-drive
