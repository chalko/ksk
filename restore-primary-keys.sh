#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
CWD="$(pwd)"

source ${DIR}/ksk.conf

if [ -d ~/gpg-primary ]; then
  echo "ERROR: ~/gpg-primary exists.  you must delete the directory to create a new primary key"
  exit 1
fi

mkdir ~/gpg-primary
chmod 700 ~/gpg-primary
rm -rf ~/ksk-secure
mkdir ~/ksk-secure
chmod 700 ~/ksk-secure

git clone ${DIR}/.git ~/ksk-secure

cp ~/ksk-secure/gpg.conf ~/gpg-primary
gpgconf --homedir ~/gpg-primary --kill gpg-agent
gpg --homedir ~/gpg-primary --batch --import ${DIR}/$KSK_ID.public.gpg-key
gpg --homedir ~/gpg-primary --batch --import ${DIR}/$KSK_ID.private.gpg-key
gpg --homedir ~/gpg-primary --import-ownertrust ~/ksk-secure/ownertrust.txt




