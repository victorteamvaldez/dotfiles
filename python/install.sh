#!/bin/sh

if test ! $(which brew)
    then echo "User must intall homebrew first"
        exit 1
fi

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

brew install pyenv
brew install pyenv-virtualenv

# Steps to install the specific Python Versions
# Had some troubles installing Python 3.8.13 and to solve it installed the following:
# brew install xz
# pyenv install 3.8.13
# To set the version globally: pyenv global 3.8.13