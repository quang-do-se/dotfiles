#!/bin/bash

if [ ! -d "~/.emacs.d/snippets" ]
then
    mkdir -p ~/.emacs.d/snippets
fi

cp ./.emacs ~/.emacs && cp ./.emacs.d/init.org ~/.emacs.d/init.org

echo -e "\nsource $(pwd)/.bashrc" >> ~/.bashrc

cp ./.gitconfig ~/.gitconfig

