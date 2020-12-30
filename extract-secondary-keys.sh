#!/bin/bash


DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

if [ ! -d ~/gpg-primary ]; then
  echo "ERROR: ~/gpg-primary does not exist exists. "
  echo "Create or restore primary keys first"
  exit 1
fi

if [ ! -d ~/secondary-secure ]; then
  mkdir ~/secondary-secure
  chmod 700 ~/secondary-secure
  git -C ~/secondary-secure init
fi


# get latest  version of the import script

cp ~/ksk/import-secondary-keys.sh ~/secondary-secure
git -C ~/secondary-secure add import-secondary-keys.sh
git -C ~/secondary-secure commit import-secondary-keys.sh -m"Copy latest version of import script"

