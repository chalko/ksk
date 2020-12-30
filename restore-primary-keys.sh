#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

if [ -d ~/gpg-primary ]; then
  echo "ERROR: ~/gpg-primary exists.  you must delete the directory to create a new primary key"
  exit 1
fi

mkdir ~/gpg-primary
chmod 700 ~/gpg-primary
rm -rf ~/ksk-secure
mkdir ~/ksk-secure
chmod 700 ~/ksk-secure


