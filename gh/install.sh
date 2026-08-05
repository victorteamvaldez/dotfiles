#!/bin/sh

if test ! $(which brew)
    then echo "User must install homebrew first"
        exit 1
fi

brew install gh