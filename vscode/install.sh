#!/bin/sh

if test ! $(which brew)
    then echo "User must install homebrew first"
        exit 1
fi

brew install --cask visual-studio-code

if test ! $(which code)
    then echo "code CLI not on PATH yet — open VS Code once, then re-run this script"
        exit 1
fi

while read -r extension; do
    code --install-extension "$extension"
done < "$(dirname "$0")/extensions.txt"

# VS Code's settings.json lives outside $HOME, so the generic *.symlink
# convention (bootstrap maps to $HOME/.<name>) doesn't reach it — link it here.
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER_DIR"
ln -sf "$(dirname "$0")/settings.json" "$VSCODE_USER_DIR/settings.json"
