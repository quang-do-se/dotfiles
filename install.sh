#!/usr/bin/env bash

set -o pipefail

trap 'catch $? $LINENO' ERR

catch() {
    echo "Shell install had error $1 on line $2"
}



BASEDIR=$(cd -- "$(dirname -- "$0")" && pwd - P)

if [ ! -d "$HOME/.emacs.d/snippets" ];
then
    mkdir -p "$HOME/.emacs.d/snippets"
fi

cp "$BASEDIR/.emacs" "$HOME/.emacs" && cp "$BASEDIR/.emacs.d/init.org" "$HOME/.emacs.d/init.org"

source_path="source $BASEDIR/shell"

if ! grep -q "$source_path" "$HOME/.bashrc"; then
    printf "\n%s" "$source_path" >> "$HOME/.bashrc"
fi

if ! grep -q "$source_path" "$HOME/.profile"; then
    printf "\n%s" "$source_path" >> "$HOME/.profile"
fi

cp "$BASEDIR/.gitconfig" "$HOME/.gitconfig"
cp "$BASEDIR/.gitexcludes" "$HOME/.gitexcludes"

sudo sh <<EOF
if [ -f /root/.bashrc ] && ! grep -q "$source_path" /root/.bashrc ; then
  printf "\n%s" "$source_path" >> /root/.bashrc
fi

if [ -d /root ] ; then
  cp "$BASEDIR/.gitconfig" /root/.gitconfig
  cp "$BASEDIR/.gitexcludes" /root/.gitexcludes
fi
EOF
