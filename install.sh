#!/bin/sh

if [ ! -d "~/.emacs.d/snippets" ]
then
    mkdir -p ~/.emacs.d/snippets
fi

cp ./.emacs ~/.emacs && cp ./.emacs.d/init.org ~/.emacs.d/init.org

source_path="source $(pwd)/shell"

if ! grep -q "$source_path" ~/.bashrc; then
    printf "\n%s" "$source_path" >> ~/.bashrc
fi

if ! grep -q "$source_path" ~/.profile; then
    printf "\n%s" "$source_path" >> ~/.profile
fi

cp ./.gitconfig ~/.gitconfig
cp ./.gitexcludes ~/.gitexcludes

sudo sh <<EOF
if [ -f /root/.bashrc ] && ! grep -q "$source_path" /root/.bashrc ; then
  printf "\n%s" "$source_path" >> /root/.bashrc
fi

if [ -d /root ] ; then
  cp ./.gitconfig /root/.gitconfig
  cp ./.gitexcludes /root/.gitexcludes
fi
EOF
