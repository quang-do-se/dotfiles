#!/usr/bin/env sh

BASEDIR=$(dirname "$0")

if [ ! -d "~/.emacs.d/snippets" ];
then
    mkdir -p ~/.emacs.d/snippets
fi

cp "$BASEDIR/.emacs" ~/.emacs && cp "$BASEDIR/.emacs.d/init.org" ~/.emacs.d/init.org

source_path="source $(pwd)/shell"

if ! grep -q "$source_path" ~/.bashrc; then
    printf "\n%s" "$source_path" >> ~/.bashrc
fi

if ! grep -q "$source_path" ~/.profile; then
    printf "\n%s" "$source_path" >> ~/.profile
fi

cp "$BASEDIR/.gitconfig" ~/.gitconfig
cp "$BASEDIR/.gitexcludes" ~/.gitexcludes

sudo sh <<EOF
if [ -f /root/.bashrc ] && ! grep -q "$source_path" /root/.bashrc ; then
  printf "\n%s" "$source_path" >> /root/.bashrc
fi

if [ -d /root ] ; then
  cp "$BASEDIR/.gitconfig" /root/.gitconfig
  cp "$BASEDIR/.gitexcludes" /root/.gitexcludes
fi
EOF
