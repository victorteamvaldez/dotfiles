#!/bin/sh

if test ! $(which brew)
    then echo "User must intall homebrew first"
        exit 1
fi

brew install --cask 1password
