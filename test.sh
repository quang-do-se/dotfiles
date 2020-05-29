#!/usr/bin/env sh

BASEDIR=$(dirname "$0")
echo "$BASEDIR"
echo "$0"
echo "$PWD"

SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH


echo "$BASH_SOURCE"
