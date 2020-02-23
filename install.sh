#!/bin/sh

if [ ! -d "~/.emacs.d/snippets" ]
then
    mkdir -p ~/.emacs.d/snippets
fi

cp ./.emacs ~/.emacs && cp ./.emacs.d/init.org ~/.emacs.d/init.org

bashrc_path="source $(pwd)/.bashrc"

if ! grep -q "$bashrc_path" ~/.bashrc; then
    printf "\n%s" "$bashrc_path" >> ~/.bashrc
fi

if (sudo test -f /root/.bashrc) && (! grep -q "$bashrc_path" /root/.bashrc); then
    sudo printf "\n%s" "$bashrc_path" >> /root/.bashrc
fi

cp ./.gitconfig ~/.gitconfig
