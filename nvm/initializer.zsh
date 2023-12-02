export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh
#   [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
#   [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

autoload -U add-zsh-hook

load-nvmrc() {

  if [[ -f .nvmrc && -r .nvmrc ]]; then

    nvm use

  elif [[ -f .node-version && -r .node-version ]]; then

    nvm use $(cat .node-version)

  elif [[ $(nvm version) != $(nvm version default)  ]]; then

    echo "Reverting to nvm default version"

    nvm use default

  fi

}

add-zsh-hook chpwd load-nvmrc

load-nvmrc