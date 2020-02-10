#!/usr/bin/env bash

set -eo nounset

check_os() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        OS_NAME="$(source /etc/os-release && echo $NAME)"

        if [[ "$OSTYPE" == "Ubuntu" ]]; then
            export BOOTSTRAP_OS="ubuntu"
        elif [[ "$OSTYPE" == "Fedora"  ]]; then
            export BOOTSTRAP_OS="fedora"
        else
            echo "Linux OS not yet supported"
            exit 0
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        export BOOTSTRAP_OS="macos"
    else
        echo "OS not yet supported"
        exit 0
    fi
}

bootstrap_vim_plugins() {
    #vimrc plugin
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
    cp shared/.vimrc ~/.vimrc

    #pathogen
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    #vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    #softlink neovim
    mkdir -p ~/.config
    ln -s ~/.vim ~/.config/nvim
    ln -s ~/.vimrc ~/.config/nvim/init.vim

    #tmux conf
    sp shared/.tmux.conf ~/.tmux.conf
}


bootstrap_bashit() {

    if [[ "$BOOTSTRAP_OS" == "macos" ]]; then
        cp "${BOOTSTRAP_OS}/.bash_profile" ~/.bash_profile
    else
        cp "${BOOTSTRAP_OS}/.bashrc" ~/.bashrc
    fi

    git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
    ~/.bash_it/install.sh
    bash-it enable completion kubectl tmux

    git clone --depth=1 https://github.com/jonmosco/kube-ps1 ~/.kube-ps1

    cp .bash_it/themes/bobby/bobby.theme.bash ~/.bash_it/themes/bobby/bobby.theme.bash

    bash-it reload
}

bootstrap_tools_macos() {
    #install brew
    ! which brew > /dev/null && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    #install tools
    brew install bash tmux vim neovim kubectl git fzf coreutils ed findutils gawk gnu-sed gnu-tar grep make python gnu-time

    #change default shell to newer bash
    chsh -s /usr/local/bin/bash
}

bootstrap_tools_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y vim neovim tmux python3-pip kubectx git fzf
    pip3 install --user ansible

    sudo apt-get update && sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
}

bootstrap_tools_fedora() {
    sudo yum update -y
    sudo yum install -y vim neovim tmux python3-pip git fzf
    pip3 install --user ansible

    #install kubectx
    git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
    COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
    ln -sf ~/.kubectx/completion/kubens.bash $COMPDIR/kubens
    ln -sf ~/.kubectx/completion/kubectx.bash $COMPDIR/kubectx
}

bootstrap() {
    [[ "$BOOTSTRAP_OS" == "macos" ]] && boostrap_tools_macos
    [[ "$BOOTSTRAP_OS" == "ubuntu" ]] && boostrap_tools_ubuntu
    [[ "$BOOTSTRAP_OS" == "fedora" ]] && boostrap_tools_fedora

    bootstrap_bashit
    bootstrap_vim_plugins
}

check_os
bootstrap

